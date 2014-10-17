require 'rails/generators/base'

module Clearance
  module Generators
    class RoutesGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def inject_clearance_routes_into_application_routes
        route(clearance_routes)
      end

      private

      def clearance_routes
        File.read(routes_file_path)
      end

      def routes_file_path
        File.expand_path(find_in_source_paths('routes.rb'))
      end
    end
  end
end