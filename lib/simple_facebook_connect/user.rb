module SimpleFacebookConnect
  
  class User

    FIELDS = [:uid, :hometown_location, :first_name, :last_name, :current_location, :pic, :locale, :email_hashes, :about_me, :interests]
    attr_reader(*FIELDS)
    attr_reader :session
    
    def initialize(uid, session)
      @uid = uid
      @session = session
      populate
    end

    def populate
      @session.post('facebook.users.getInfo', :fields => coma_seperated_fields, :uids => uid) do |response|
        FIELDS.each do |field|
          instance_variable_set(:"@#{field}", response.first[field.to_s])
        end
      end
    end
  
    def coma_seperated_fields
      FIELDS.join(',')
    end
  
  end
end