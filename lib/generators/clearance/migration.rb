require "rails/generators/active_record"

module Clearance
  module Generators
    module Migration
      def self.included(base)
        base.include Rails::Generators::Migration
        base.extend ClassMethods
      end

      module ClassMethods
        # for generating a timestamp when using `create_migration`
        def next_migration_number(dir)
          ActiveRecord::Generators::Base.next_migration_number(dir)
        end
      end

      def copy_migration(migration_name, config = {})
        unless self.class.migration_exists?("db/migrate", migration_name)
          migration_template(
            "db/migrate/#{migration_name}",
            "db/migrate/#{migration_name}",
            config
          )
        end
      end
    end
  end
end
