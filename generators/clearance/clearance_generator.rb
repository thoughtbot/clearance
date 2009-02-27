require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")
require 'factory_girl'

class ClearanceGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("app", "controllers")
      if Rails.version >= "2.3.0"
        file = "app/controllers/application_controller.rb"
      else
        file = "app/controllers/application.rb"
      end
      if File.exists?(file)
        m.insert_into file, "include Clearance::App::Controllers::ApplicationController"
      else
        m.file file, file 
      end

      ["app/controllers/confirmations_controller.rb",
       "app/controllers/passwords_controller.rb", 
       "app/controllers/sessions_controller.rb", 
       "app/controllers/users_controller.rb"].each do |file|
        m.file file, file
      end

      m.directory File.join("app", "models")
      ["app/models/user.rb", "app/models/clearance_mailer.rb"].each do |file|
        m.file file, file
      end

      m.directory File.join("app", "views")

      m.directory File.join("app", "views", "passwords")
      ["app/views/passwords/new.html.erb",
       "app/views/passwords/edit.html.erb"].each do |file|
        m.file file, file
      end

      m.directory File.join("app", "views", "sessions")
      ["app/views/sessions/new.html.erb"].each do |file|
        m.file file, file
      end

      m.directory File.join("app", "views", "clearance_mailer")
      ["app/views/clearance_mailer/change_password.html.erb",
       "app/views/clearance_mailer/confirmation.html.erb"].each do |file|
        m.file file, file
      end

      m.directory File.join("app", "views", "users")
      ["app/views/users/_form.html.erb",
       "app/views/users/edit.html.erb",
       "app/views/users/new.html.erb"].each do |file|
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
