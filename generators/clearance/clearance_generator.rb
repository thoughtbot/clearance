class ClearanceGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      ["app/controllers/confirmations_controller.rb",
       "app/controllers/passwords_controller.rb", 
       "app/controllers/sessions_controller.rb", 
       "app/controllers/users_controller.rb",
       "app/models/user.rb",
       "app/models/user_mailer.rb",
       "test/functional/confirmations_controller_test.rb",
       "test/functional/passwords_controller_test.rb",
       "test/functional/sessions_controller_test.rb",
       "test/functional/users_controller_test.rb",
       "test/unit/user_mailer_test.rb",
       "test/unit/user_test.rb"].each do |file|
        m.file file, file
      end
    end
  end
  
end