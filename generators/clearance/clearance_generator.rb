class ClearanceGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory File.join("app", "controllers")
      ["app/controllers/confirmations_controller.rb",
       "app/controllers/passwords_controller.rb", 
       "app/controllers/sessions_controller.rb", 
       "app/controllers/users_controller.rb"].each do |file|
        m.file file, file
      end
      
      m.directory File.join("app", "models")
      ["app/models/user.rb",
       "app/models/user_mailer.rb"].each do |file|
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
      
      m.directory File.join("app", "views", "user_mailer")
      ["app/views/user_mailer/change_password.html.erb",
       "app/views/user_mailer/confirmation.html.erb"].each do |file|
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
      ["test/unit/user_mailer_test.rb",
       "test/unit/user_test.rb"].each do |file|
        m.file file, file
      end
      
      ["test/factories.rb"].each do |file|
        m.file file, file
      end
    end
  end
  
end