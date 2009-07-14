class SimpleFacebookConnectFeaturesGenerator < Rails::Generator::Base
  def manifest
    record do |r|
      r.file 'facebook_connect.feature', "features/facebook_connect.feature"
      r.file 'facebook_connect_steps.rb', "features/step_definitions/facebook_connect_steps.rb"
      r.file 'facebook_connect_stubs.rb', "features/support/facebook_connect_stubs.rb"
      
      r.directory 'features/fixtures/facebook.auth.getSession'
      r.file 'facebook_auth_getsession.xml', "features/fixtures/facebook.auth.getSession/default.xml"
      r.directory 'features/fixtures/facebook.users.getInfo'
      r.file 'facebook_users_getinfo.xml', "features/fixtures/facebook.users.getInfo/default.xml"
    end
  end
end