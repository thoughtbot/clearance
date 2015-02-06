require "rails/generators/base"
require "generators/clearance/migration"

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Clearance::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_clearance_initializer
        copy_file 'clearance.rb', 'config/initializers/clearance.rb'
      end

      def inject_clearance_into_application_controller
        inject_into_class(
          "app/controllers/application_controller.rb",
          ApplicationController,
          "  include Clearance::Controller\n"
        )
      end

      def create_or_inject_clearance_into_user_model
        if File.exist? "app/models/user.rb"
          inject_into_file(
            "app/models/user.rb",
            "include Clearance::User\n\n",
            after: "class User < ActiveRecord::Base\n"
          )
        else
          copy_file 'user.rb', 'app/models/user.rb'
        end
      end

      def create_clearance_users_migration
        if users_table_exists?
          create_add_columns_migration
        else
          copy_migration 'create_users.rb'
        end
      end

      def invoke_password_reset_migration_generator
        invoke "clearance:password_reset_migration"
      end

      def display_readme_in_terminal
        readme 'README'
      end

      private

      def create_add_columns_migration
        if migration_needed?
          config = {
            new_columns: new_columns,
            new_indexes: new_indexes
          }

          copy_migration('add_clearance_to_users.rb', config)
        end
      end

      def migration_needed?
        new_columns.any? || new_indexes.any?
      end

      def new_columns
        @new_columns ||= {
          email: 't.string :email',
          encrypted_password: 't.string :encrypted_password, limit: 128',
          remember_token: 't.string :remember_token, limit: 128'
        }.reject { |column| existing_users_columns.include?(column.to_s) }
      end

      def new_indexes
        @new_indexes ||= {
          index_users_on_email: 'add_index :users, :email',
          index_users_on_remember_token: 'add_index :users, :remember_token'
        }.reject { |index| existing_users_indexes.include?(index.to_s) }
      end

      def existing_users_columns
        ActiveRecord::Base.connection.columns(:users).map(&:name)
      end

      def users_table_exists?
        ActiveRecord::Base.connection.table_exists?(:users)
      end

      def existing_users_indexes
        ActiveRecord::Base.connection.indexes(:users).map(&:name)
      end
    end
  end
end
