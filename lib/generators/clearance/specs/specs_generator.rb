require 'rails/generators/base'
require 'rspec/rails/version'

module Clearance
  module Generators
    class SpecsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_specs
        @helper_file = rspec_helper_file
        directory '.', 'spec'
      end

      private

      def rspec_helper_file
        if RSpec::Rails::Version::STRING.to_i > 2
          "rails_helper"
        else
          "spec_helper"
        end
      end
    end
  end
end
