require "rails/generators/base"
require "rails/generators/active_record"

module Clearance
  module Generators
    class UpgradeGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("../templates", __FILE__)

      # for generating a timestamp when using `create_migration`
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def change_users_table
        migration_name = "remove_confirmation_token_from_users.rb"

        migration_template(
          "db/migrate/#{migration_name}.tt",
          "db/migrate/#{migration_name}",
          migration_version: migration_version,
        )
      end

      private

      def migration_version
        if Rails.version >= "5.0.0"
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  end
end
