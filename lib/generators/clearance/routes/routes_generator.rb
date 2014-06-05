require 'rails/generators/base'

module Clearance
  module Generators
    class RoutesGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def disable_clearance_routes_in_config
        inject_into_file(
          'config/initializers/clearance.rb',
          "  config.routes = false\n",
          after: /^Clearance\.configure do |config|\n/
        )
      end

      def inject_clearance_routes_into_application_routes
        route(clearance_routes)
      end

      private

      def clearance_routes
        routes_file_path = File.expand_path(find_in_source_paths("routes.rb"))
        File.read(routes_file_path)
      end
    end
  end
end
