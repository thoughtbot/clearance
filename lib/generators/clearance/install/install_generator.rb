require 'rails/generators/active_record'

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)
      argument :user_class, type: :string, default: "User"
      argument :password_reset_class, type: :string, default: "PasswordReset"

      def add_routes
        route(clearance_routes)
      end

      def add_controller_helpers
        inject_into_class(
          "app/controllers/application_controller.rb",
          ApplicationController,
          "  include Monban::ControllerHelpers\n"
        )
      end

      def create_password_resets_table
        migration_template "db/migrate/create_password_resets.rb", "db/migrate/create_password_resets.rb"
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      private

      def clearance_routes
        routes_file_path = File.expand_path(
          find_in_source_paths("routes/routes.erb")
        )

        ERB.new(File.read(routes_file_path)).result(binding)
      end
    end
  end
end
