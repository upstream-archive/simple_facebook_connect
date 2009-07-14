# without this hack people can't override our routes when subclassing controllers in the app. trick stolen from clearance.
class ActionController::Routing::RouteSet
  def load_routes_with_simple_facebook_connect!
    lib_path = File.dirname(__FILE__)
    routes = File.join(lib_path, *%w[.. .. .. config simple_facebook_connect_routes.rb])
    unless configuration_files.include?(routes)
      add_configuration_file(routes)
    end
    load_routes_without_simple_facebook_connect!
  end

  alias_method_chain :load_routes!, :simple_facebook_connect
end