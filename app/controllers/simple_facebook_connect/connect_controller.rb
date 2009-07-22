module SimpleFacebookConnect
  class ConnectController < ApplicationController
  
    def authenticate
      redirect_to new_facebook_session.login_url
    end
  
    def connect
      begin
        new_facebook_session(params['auth_token'])
        if facebook_user
          unless log_in_via_fb_id(facebook_user) || log_in_via_email_hash(facebook_user)
            redirect_to(signup_path)
          end
        else
          render(:nothing => true)
        end
      rescue FacebookApiError => e
        Rails.logger.warn e.message
        redirect_to fb_authenticate_path
      end
    end
  
    private
    
    def signup_path
      new_user_path(:fb_user => 1)
    end
  
    def new_facebook_session(token = nil)
      facebook_session = Session.new(SimpleFacebookConnect.api_key, SimpleFacebookConnect.secret_key)
      if token
        facebook_session.auth_token = token
        facebook_session.secure!
        session[:facebook_session] = facebook_session
      end
      facebook_session
    end
  
    def log_in_via_fb_id(facebook_user)
      if user = ::User.find_by_fb_uid(facebook_user.uid)
        log_in(user)
        true
      end
    end
  
    def log_in_via_email_hash(facebook_user)
      facebook_user.email_hashes.each do |hash|
        if user = ::User.find_by_email_hash(hash)
          user.update_attribute(:fb_uid, facebook_user.uid)
          log_in(user)
          return true
        end
      end
      false
    end

  end
end