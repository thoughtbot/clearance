require 'rails/generators/base'

module Clearance
  module Generators
    class SpecsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_specs
        directory '.', 'spec'
      end
    end
  end
end
