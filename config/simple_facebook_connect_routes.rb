ActionController::Routing::Routes.draw do |map|
  map.fb_connect '/fb/connect', :controller => 'simple_facebook_connect/connect', :action => 'connect'
  map.fb_authenticate '/fb/authenticate', :controller => 'simple_facebook_connect/connect', :action => 'authenticate'
end