require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")
require 'factory_girl'

class ClearanceGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("app", "controllers")
      file = "app/controllers/application_controller.rb"
      m.insert_into file, "include Clearance::Authentication"

      m.directory File.join("app", "models")
      ["app/models/user.rb"].each do |file|
        m.file file, file
      end

      m.directory File.join("test", "functional")
      ["test/functional/confirmations_controller_test.rb",
       "test/functional/passwords_controller_test.rb",
       "test/functional/sessions_controller_test.rb",
       "test/functional/users_controller_test.rb"].each do |file|
        m.file file, file
      end

      m.directory File.join("test", "unit")
      ["test/unit/clearance_mailer_test.rb",
       "test/unit/user_test.rb"].each do |file|
        m.file file, file
      end

      m.directory File.join("test", "factories")
      ["test/factories/clearance.rb"].each do |file|
        m.file file, file
      end

      m.route_resources ':passwords'
      m.route_resource  ':session'
      m.route_resources ':users, :has_one => [:password, :confirmation]'

      if ActiveRecord::Base.connection.table_exists?(:users)
        m.migration_template 'db/migrate/update_users_with_clearance_columns.rb', 
          'db/migrate', :migration_file_name => 'create_or_update_users_with_clearance_columns'
      else
        m.migration_template 'db/migrate/create_users_with_clearance_columns.rb', 
          'db/migrate', :migration_file_name => 'create_or_update_users_with_clearance_columns'
      end

      m.rake_db_migrate

      m.readme "README"
    end
  end

end
