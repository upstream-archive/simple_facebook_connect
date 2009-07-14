module SimpleFacebookConnect
  module ControllerExtension
    def facebook_session
      session[:facebook_session]
    end

    def facebook_user
      (session[:facebook_session] && session[:facebook_session].session_key) ? session[:facebook_session].user : nil
    end
  end
end