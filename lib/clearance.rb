require 'clearance/extensions/errors'
require 'clearance/extensions/rescue'

require 'clearance/authentication'
require 'clearance/user'

class ActionController::Routing::RouteSet
  def load_routes_with_clearance!
    clearance_routes = File.join(File.dirname(__FILE__), *%w[.. config clearance_routes.rb])
    add_configuration_file(clearance_routes) unless configuration_files.include? clearance_routes
    load_routes_without_clearance!
  end

  alias_method_chain :load_routes!, :clearance
end
