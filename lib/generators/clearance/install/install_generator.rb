require 'rails/generators/base'
require 'rails/generators/active_record'

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
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
            "  include Clearance::User\n\n",
            after: "class User < #{models_inherit_from}\n",
          )
        else
          @inherit_from = models_inherit_from
          template("user.rb.erb", "app/models/user.rb")
        end
      end

      def create_clearance_migration
        if users_table_exists?
          create_add_columns_migration
        else
          copy_migration "create_users"
        end
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

          copy_migration("add_clearance_to_users", config)
        end
      end

      def copy_migration(migration_name, config = {})
        unless migration_exists?(migration_name)
          migration_template(
            "db/migrate/#{migration_name}.rb.erb",
            "db/migrate/#{migration_name}.rb",
            config.merge(migration_version: migration_version),
          )
        end
      end

      def migration_needed?
        new_columns.any? || new_indexes.any?
      end

      def new_columns
        @new_columns ||= {
          email: "t.string :email",
          encrypted_password: "t.string :encrypted_password, limit: 128",
          confirmation_token: "t.string :confirmation_token, limit: 128",
          remember_token: "t.string :remember_token, limit: 128",
        }.reject { |column| existing_users_columns.include?(column.to_s) }
      end

      def new_indexes
        @new_indexes ||= {
          index_users_on_email:
            "add_index :users, :email",
          index_users_on_confirmation_token:
            "add_index :users, :confirmation_token, unique: true",
          index_users_on_remember_token:
            "add_index :users, :remember_token, unique: true",
        }.reject { |index| existing_users_indexes.include?(index.to_s) }
      end

      def migration_exists?(name)
        existing_migrations.include?(name)
      end

      def existing_migrations
        @existing_migrations ||= Dir.glob("db/migrate/*.rb").map do |file|
          migration_name_without_timestamp(file)
        end
      end

      def migration_name_without_timestamp(file)
        file.sub(%r{^.*(db/migrate/)(?:\d+_)?}, '')
      end

      def users_table_exists?
        ActiveRecord::Base.connection.data_source_exists?(:users)
      end

      def existing_users_columns
        ActiveRecord::Base.connection.columns(:users).map(&:name)
      end

      def existing_users_indexes
        ActiveRecord::Base.connection.indexes(:users).map(&:name)
      end

      # for generating a timestamp when using `create_migration`
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end

      def migration_primary_key_type_string
        if configured_key_type
          ", id: :#{configured_key_type}"
        end
      end

      def configured_key_type
        active_record = Rails.configuration.generators.active_record
        active_record ||= Rails.configuration.generators.options[:active_record]

        active_record[:primary_key_type]
      end

      def models_inherit_from
        "ApplicationRecord"
      end
    end
  end
end
