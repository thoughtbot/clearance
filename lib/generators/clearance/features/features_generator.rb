require 'rails/generators/base'

module Clearance
  module Generators
    class FeaturesGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_features
        directory 'features'
      end

      def create_factories
        directory 'spec'
      end
    end
  end
end
