module SimpleFacebookConnect
  
  class Session
    API_SERVER_BASE_URL       = "api.facebook.com"
    API_PATH_REST             = "/restserver.php"
    WWW_SERVER_BASE_URL       = "www.facebook.com"
    WWW_PATH_LOGIN            = "/login.php"

    attr_accessor :auth_token
    attr_reader :session_key


    def initialize(api_key, secret_key)
      @api_key        = api_key
      @secret_key     = secret_key
      @session_key    = nil
      @uid            = nil
      @auth_token     = nil
      @secret_from_session = nil
      @expires        = nil
    end
  
    def login_url(options={})
      "http://#{WWW_SERVER_BASE_URL}#{WWW_PATH_LOGIN}?api_key=#{@api_key}&v=1.0"
    end
  

    def secure!
      response = post 'facebook.auth.getSession', :auth_token => auth_token
      @session_key = response['session_key']
      @uid = response['uid'].to_i
      @expires = response['expires'].to_i
      @secret_from_session = response['secret']
    end    

    def user
      @user ||= User.new(uid, self)
    end
  
    def post(method, params = {}, use_session_key = true, &proc)
      add_facebook_params(params, method)
      use_session_key && @session_key && params[:session_key] ||= @session_key
      final_params = params.merge(:sig => signature_for(params))
      result = service.post(final_params)
      result = yield result if block_given?
      result
    end

    private
    def add_facebook_params(hash, method)
      hash[:method] = method
      hash[:api_key] = @api_key
      hash[:call_id] = Time.now.to_f.to_s unless method == 'facebook.auth.getSession'
      hash[:v] = "1.0"
    end

    def service
      @service ||= Service.new(API_SERVER_BASE_URL, API_PATH_REST, @api_key)      
    end

    def uid
      @uid || (secure!; @uid)
    end

    def signature_for(params)
      raw_string = params.inject([]) do |collection, pair|
        collection << pair.join("=")
        collection
      end.sort.join
      Digest::MD5.hexdigest([raw_string, @secret_key].join)
    end
  end
end