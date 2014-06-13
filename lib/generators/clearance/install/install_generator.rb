require 'rails/generators/active_record'

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)
      argument :user_class, type: :string, default: "User"
      argument :password_reset_class, type: :string, default: "PasswordReset"

      def add_routes
        route(%{get "sign_up" => "clearance/sign_ups#new"})
        route(%{post "sign_up" => "clearance/sign_ups#create"})
        route(%{get "sign_in" => "clearance/sessions#new"})
        route(%{post "sign_in" => "clearance/sessions#create"})
        route(%{delete "sign_out" => "clearance/sessions#destroy"})
        route(%{resource :password_reset, only: [:new, :create, :edit], controller: "clearance/password_resets"})
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
    end
  end
end
