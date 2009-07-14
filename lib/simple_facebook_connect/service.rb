require 'net/http'

module SimpleFacebookConnect
  
  class Service
    def initialize(api_base, api_path, api_key)
      @api_base = api_base
      @api_path = api_path
      @api_key = api_key
    end
  
    def post(params)
      attempt = 0
      Parser.parse(params[:method], post_form(url,params) )
    rescue Errno::ECONNRESET, EOFError
      if attempt == 0
        attempt += 1
        retry
      end
    end
  
    def post_form(url,params)
      Net::HTTP.post_form(url, params.stringify_keys)
    end
  
    private
    def url(base = nil)
      base ||= @api_base
      URI.parse('http://'+ base + @api_path)
    end
  
  
  end
end