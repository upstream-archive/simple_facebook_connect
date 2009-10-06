$LOAD_PATH << File.dirname(__FILE__)

require 'simple_facebook_connect/parser'
require 'simple_facebook_connect/service'
require 'simple_facebook_connect/session'
require 'simple_facebook_connect/user'
require 'simple_facebook_connect/active_record_extension'
require 'simple_facebook_connect/user_extension'
require 'simple_facebook_connect/controller_extension'

module SimpleFacebookConnect
  class << self
    attr_accessor :api_key, :secret_key
  end
end