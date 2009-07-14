## Simple Facebook Connect

This plugin adds the ability to sign in/sign up using facebook connect to your Rails application.

## Disclaimer

Most of the code here is a direct rip-off of the facebooker gem. We wanted something much simpler than facebooker so we took the code we needed, refactored and changed bits and pieces and here we are.

## Basic process

With this plugin you will add the well know facebook connect button to your site. When a visitor clicks on it:

* she will be redirected to facebook
* after signing in at facebook be directed back to your signup page
* there she will sign up as usual but without being asked to enter a password
* after signing up she will be able to sign into your site by clicking the facebook connect button

When an existing user of your site clicks the button he will also be able to log in via facebook, given the email address he signed up with at your site is also known to facebook.

## Installation

This plugin assumes you have a `User` model with an `email` attribute. It will add some extensions to your `User` model and controllers in order to provide the necessary hooks and calls for facebook to authenticate your users.

Install the gem:

    sudo gem install upstream-simple_facebook_connect
    
Add it as a dependency to your Rails application:

    # environment.rb
    gem 'upstream-simple_facebook_connect', :source => 'http://gems.github.com'
    
Run the migration generator and migrate:

    script/generate simple_facebook_connect_migration
    rake db:migrate
    rake db:test:clone
    
Add the facebook connect button to your sign up and/or sign in pages. We have prepared a partial for you:

    <%= render :partial => 'shared/facebook_connect_button' %>
    
Add this to your signup action (`users/create` in most cases):

    class UsersController < ApplicationController
      def create
        @user = # initialize user
        ....
        @user.fb_uid = facebook_user.uid if facebook_user
        @user.save
      end
    end
    
Change your signup form to not show any password fields when signing up via facebook:

    <%- unless facebook_user -%>
      <%= f.password_field :password -%>
      ...
    <%- end -%>
    
Provide a `log_in(user)` method, either in your `ApplicationController` or by subclassing `SimpleFacebookConnect::ConnectController`:

    class AppicationController < ActionController::Base
    
      ...
      
      private
      
      def log_in(user)
        session[:user_id] = user.id # or whatever your app does
        redirect_to account_path
      end
    end
    
Optional step (well, you really should do this): Generate Cucumber Features:

    script/generate simple_facebook_connect_features
    
This will generate a feature, step definitions and fixtures to test the facebook connect integration. You will probably have to adjust those files to fit your app, for example we are using _Machinist_ to generate `User` instances.

Finally: run the features and by now everything should be green. Congrats.

## Links

* facebooker: http://facebooker.rubyforge.org/
* contact: http://upstream-berlin.com
* email: alex [at] upstream-berlin dot com


Copyright (c) 2009 Alexander Lang, Frank Prößdorf, released under the MIT license
