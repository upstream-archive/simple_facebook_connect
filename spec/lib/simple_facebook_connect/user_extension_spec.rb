require File.dirname(__FILE__) + '/../../spec_helper'

describe SimpleFacebookConnect::UserExtension, 'email=' do
  class User < ActiveRecord::Base
    facebook_user
    
  end
  
  it "should set the email hash" do
    user = User.new
    user.email = 'joe@doe.com'
    user.save!
    user.email_hash.should == '3404385302_68ef883c573edb5d26365e8f20156eec'
    
  end
end