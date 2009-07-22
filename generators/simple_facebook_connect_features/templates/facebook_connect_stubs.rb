module SimpleFacebookConnect
  module ServiceStub
    def read_fixture(method)
      if File.exists?(fixture_path(method, 'default'))
        File.read fixture_path(method, 'default')
      else
        raise "Missing fixture #{fixture_path(method, 'default')}\nFacebook API Reference: http://wiki.developers.facebook.com/index.php/#{method.sub(/^facebook\./, '')}#Example_Return_XML"
      end
    end

    def post(params)
      method = params.delete(:method)
      params.delete_if {|k,_| [:v, :api_key, :call_id, :sig].include?(k) }
      Parser.parse(method, read_fixture(method))
    end

    private

    def fixture_path(method, filename)
      File.join(Rails.root + 'features/fixtures', method, "#{filename}.xml")
    end
  end

  module SessionStub
    def service
      unless @service
        service = Service.new(Session::API_SERVER_BASE_URL, Session::API_PATH_REST, @api_key)
        service.extend(ServiceStub)
        @service = service
      else
        @service
      end
    end
  end
end

SimpleFacebookConnect::Session.class_eval do
  def self.new(*args)
    session = super
    session.extend SimpleFacebookConnect::SessionStub
    session
  end
end
