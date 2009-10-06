__DIR__ = File.dirname __FILE__
$LOAD_PATH.unshift __DIR__ + '/../lib'

require 'simple_facebook_connect'
require 'fileutils'
require 'rubygems'
Gem::RubyGemsVersion.inspect # without this the activerecord gem doesn't load on ruby 1.9 #WTF
require 'sqlite3'
gem 'activerecord'
require 'activerecord'



FileUtils.rm_rf __DIR__ + '/../test.sqlite3'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => File.join(__DIR__, '..', 'test.sqlite3')

# migrate

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
    end
  end
end

require __DIR__ + '/../generators/simple_facebook_connect_migration/templates/migration'

CreateUsers.up
AddFacebookConnect.up

ActiveRecord::Base.send(:include, SimpleFacebookConnect::ActiveRecordExtension)
