require "rails/generators/base"

module Clearance
  module Generators
    class RoutesGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def inject_clearance_routes_into_application_routes
        route(clearance_routes)
      end

      def disable_clearance_internal_routes
        inject_into_file(
          "config/initializers/clearance.rb",
          "  config.routes = false\n",
          after: "Clearance.configure do |config|\n"
        )
      end

      private

      def clearance_routes
        File.read(routes_file_path)
      end

      def routes_file_path
        File.expand_path(find_in_source_paths("routes.rb"))
      end

      def route(routing_code)
        log :route, "all clearance routes"
        sentinel = /\.routes\.draw do\s*\n/m

        in_root do
          inject_into_file(
            "config/routes.rb",
            routing_code,
            after: sentinel,
            verbose: false,
            force: true
          )
        end
      end
    end
  end
end
