require 'rails/generators/base'

module Clearance
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root Clearance.root

      def create_views
        directory views, 'app/views/'
      end

      def create_locales
        directory locales, 'config/locales/'
      end

      private

      def views
        if defined?(SimpleForm)
          directory_within_root 'lib/generators/clearance/templates/simple_form'
        else
          directory_within_root 'app/views'
        end
      end

      def locales
        directory_within_root 'config/locales'
      end

      def directory_within_root(directory)
        "#{self.class.source_root}/#{directory}"
      end
    end
  end
end
