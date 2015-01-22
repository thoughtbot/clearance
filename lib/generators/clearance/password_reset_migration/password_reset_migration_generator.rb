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

      def creates_confirmation_token_removal_migration
        copy_migration "remove_confirmation_token_from_users.rb"
      end
    end
  end
end
