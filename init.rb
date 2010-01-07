require File.dirname(__FILE__) + '/lib/simple_facebook_connect'

config_file = Rails.root + 'config/simple_facebook_connect.yml'

unless File.exist?(config_file)
  File.open(config_file, 'w') do |f|
    f << <<-CONF
test:
  api_key:
  secret_key: 

development:
  api_key:
  secret_key: 

production:
  api_key:
  secret_key: 
  
CONF
  end
  
  puts "Created the facebook simple connect configuration in #{config_file}. Please enter your facebook API and secret keys there."
  exit(1)
end

config = YAML::load(File.read(config_file))[Rails.env]

SimpleFacebookConnect.api_key = config['api_key']
SimpleFacebookConnect.secret_key = config['secret_key']

ActionController::Base.send(:include, SimpleFacebookConnect::ControllerExtension)
ActiveRecord::Base.send(:include, SimpleFacebookConnect::ActiveRecordExtension) if defined?(ActiveRecord)

require 'simple_facebook_connect/extensions/routes'
