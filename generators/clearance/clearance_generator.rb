class ClearanceGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory File.join("app", "controllers")
      file = "app/controllers/application.rb"
      application_controller_exists = File.exists?(destination_path(file))
      m.file file, file, :collision => :skip
      
      ["app/controllers/confirmations_controller.rb",
       "app/controllers/passwords_controller.rb", 
       "app/controllers/sessions_controller.rb", 
       "app/controllers/users_controller.rb"].each do |file|
        m.file file, file
      end
      
      m.directory File.join("app", "models")
      file = "app/models/user.rb"
      user_model_exists = File.exists?(destination_path(file))
      m.file file, file, :collision => :skip
     
      ["app/models/clearance_mailer.rb"].each do |file|
        m.file file, file
      end
      
      m.directory File.join("app", "views")
      m.directory File.join("app", "views", "confirmations")
      ["app/views/confirmations/new.html.erb"].each do |file|
        m.file file, file
      end
      
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
      
      ["test/factories.rb"].each do |file|
        m.file file, file
      end
      
      if ActiveRecord::Base.connection.table_exists?(:users)      
        m.migration_template 'db/migrate/update_users_with_clearance_columns.rb', 
          'db/migrate', :migration_file_name => 'update_users_with_clearance_columns'
      else
        m.migration_template 'db/migrate/create_users_with_clearance_columns.rb', 
          'db/migrate', :migration_file_name => 'create_users_with_clearance_columns'
      end
      
      m.readme "USER_MODEL_EXISTS" if user_model_exists
      m.readme "APPLICATION_CONTROLLER_EXISTS" if application_controller_exists      
    end
  end
  
end
