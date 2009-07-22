require 'rexml/document'

module SimpleFacebookConnect
  
  class FacebookApiError < StandardError; end
  
  class Parser
    
    module REXMLElementExtensions
      def text_value
        self.children.first.to_s.strip
      end
    end
  
    ::REXML::Element.__send__(:include, REXMLElementExtensions)
  
    def self.parse(method, data)
      Errors.process(data)
      parser = PARSERS[method]
      parser.process(
        data
      )
    end
  
    def self.array_of(response_element, element_name)
      values_to_return = []
      response_element.elements.each(element_name) do |element|
        values_to_return << yield(element)
      end
      values_to_return
    end
  
    def self.array_of_text_values(response_element, element_name)
      array_of(response_element, element_name) do |element|
        element.text_value
      end
    end

    def self.array_of_hashes(response_element, element_name)
      array_of(response_element, element_name) do |element|
        hashinate(element)
      end
    end
  
    def self.element(name, data)
      data = data.body rescue data # either data or an HTTP response
      doc = REXML::Document.new(data)
      doc.elements.each(name) do |element|
        return element
      end
      raise "Element #{name} not found in #{data}"
    end
  
    def self.hash_or_value_for(element)
      if element.children.size == 1 && element.children.first.kind_of?(REXML::Text)
        element.text_value
      else
        hashinate(element)
      end
    end
  
    def self.hashinate(response_element)
      response_element.children.reject{|c| c.kind_of? REXML::Text}.inject({}) do |hash, child|
        # If the node hasn't any child, and is not a list, we want empty strings, not empty hashes,
        #   except if attributes['nil'] == true
        hash[child.name] = 
        if (child.attributes['nil'] == 'true')
          nil 
        elsif (child.children.size == 1 && child.children.first.kind_of?(REXML::Text)) || (child.children.size == 0 && child.attributes['list'] != 'true')
          anonymous_field_from(child, hash) || child.text_value
        elsif child.attributes['list'] == 'true'
          child.children.reject{|c| c.kind_of? REXML::Text}.map { |subchild| hash_or_value_for(subchild)}    
        else
          child.children.reject{|c| c.kind_of? REXML::Text}.inject({}) do |subhash, subchild|
            subhash[subchild.name] = hash_or_value_for(subchild)
            subhash
          end
        end #if (child.attributes)
        hash
      end #do |hash, child|      
    end
  
    def self.booleanize(response)
      response == "1" ? true : false
    end
  
    def self.anonymous_field_from(child, hash)
      if child.name == 'anon'
        (hash[child.name] || []) << child.text_value
      end
    end
  
    class RevokeAuthorization < self
      def self.process(data)
        booleanize(data)
      end
    end

    class CreateToken < self
      def self.process(data)
        element('auth_createToken_response', data).text_value
      end
    end

    class RegisterUsers < self
      def self.process(data)
        array_of_text_values(element("connect_registerUsers_response", data), "connect_registerUsers_response_elt")
      end
    end

    class GetSession < self
      def self.process(data)      
        hashinate(element('auth_getSession_response', data))
      end
    end

    class UserInfo < self
      def self.process(data)
        array_of_hashes(element('users_getInfo_response', data), 'user')
      end
    end

    class UserStandardInfo < self
      def self.process(data)
        array_of_hashes(element('users_getStandardInfo_response', data), 'standard_user_info')
      end
    end

    class GetLoggedInUser < self
      def self.process(data)
        Integer(element('users_getLoggedInUser_response', data).text_value)
      end
    end

    class ProfileInfo < self
      def self.process(data)
        hashinate(element('profile_getInfo_response info_fields', data))
      end
    end

    class Errors < self
      def self.process(data)
        response_element = element('error_response', data) rescue nil
        if response_element
          hash = hashinate(response_element)
          raise FacebookApiError, hash['error_msg']
        end
      end
    end
  
  
    PARSERS = {
      'facebook.auth.revokeAuthorization' => RevokeAuthorization,
      'facebook.auth.createToken' => CreateToken,
      'facebook.auth.getSession' => GetSession,
      'facebook.connect.registerUsers' => RegisterUsers,
      'facebook.users.getInfo' => UserInfo,
      'facebook.users.getStandardInfo' => UserStandardInfo,
      'facebook.profile.getInfo' => ProfileInfo
    }

  end  
end