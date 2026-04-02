require "rails/generators/base"
require "rails/generators/active_record"

module Clearance
  module Generators
    class PasskeysGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      # Required by Rails::Generators::Migration to produce timestamped filenames.
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def create_migrations
        copy_migration("add_webauthn_id_to_users") unless webauthn_id_column_exists?
        copy_migration("create_passkeys") unless passkeys_table_exists?
      end

      private

      def copy_migration(migration_name)
        unless migration_exists?(migration_name)
          migration_template(
            "db/migrate/#{migration_name}.rb.erb",
            "db/migrate/#{migration_name}.rb",
            migration_version: migration_version
          )
        end
      end

      def webauthn_id_column_exists?
        users_table_exists? &&
          connection.columns(:users).map(&:name).include?("webauthn_id")
      end

      def users_table_exists?
        connection.data_source_exists?(:users)
      end

      def passkeys_table_exists?
        connection.data_source_exists?(:passkeys)
      end

      def migration_exists?(name)
        existing_migrations.include?(name)
      end

      def existing_migrations
        @existing_migrations ||= Dir.glob("db/migrate/*.rb").map do |file|
          file.sub(%r{^.*(db/migrate/)(?:\d+_)?}, "").chomp(".rb")
        end
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end

      def connection
        ActiveRecord::Base.connection
      end
    end
  end
end
