require "rails/generators/base"
require "generators/clearance/migration"

module Clearance
  module Generators
    class PasswordResetMigrationGenerator < Rails::Generators::Base
      include Clearance::Generators::Migration
      source_root File.expand_path("../templates", __FILE__)

      def create_password_resets_migration
        copy_migration "create_password_resets.rb"
      end
    end
  end
end
