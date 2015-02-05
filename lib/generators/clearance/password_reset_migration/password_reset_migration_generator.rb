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
        if users_table_exists? && confirmation_token_column_exists?
          copy_migration "remove_confirmation_token_from_users.rb"
        end
      end

      private

      def confirmation_token_column_exists?
        existing_users_columns.include? "confirmation_token"
      end

      def users_table_exists?
        ActiveRecord::Base.connection.table_exists?(:users)
      end

      def existing_users_columns
        ActiveRecord::Base.connection.columns(:users).map(&:name)
      end
    end
  end
end
