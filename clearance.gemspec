Gem::Specification.new do |s|
  s.name = "clearance"
  s.version = "0.2.0"
  s.date = "2008-10-11"
  s.summary = "Simple, complete Rails authentication."
  s.email = "dcroak@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/clearance"
  s.description = "Simple, complete Rails authentication scheme."
  s.authors = ["thoughtbot, inc.", "Dan Croak", "Josh Nichols", "Mike Breen", "Mike Burns", "Jason Morrison"]
  s.files = ["README.textile",
    "clearance.gemspec",
    "generators/clearance/clearance_generator.rb",
    "generators/clearance/templates/app/.rb",
    "generators/clearance/templates/app/controllers/confirmations_controller.rb",
    "generators/clearance/templates/app/controllers/passwords_controller.rb",
    "generators/clearance/templates/app/controllers/sessions_controller.rb",
    "generators/clearance/templates/app/controllers/users_controller.rb",
    "generators/clearance/templates/app/models/user.rb",
    "generators/clearance/templates/app/models/user_mailer.rb",
    "generators/clearance/templates/app/views/confirmations/new.html.erb",
    "generators/clearance/templates/app/views/passwords/edit.html.erb",
    "generators/clearance/templates/app/views/passwords/new.html.erb",
    "generators/clearance/templates/app/views/sessions/new.htmlerb",
    "generators/clearance/templates/app/views/user_mailer/change_password.htmlerb",
    "generators/clearance/templates/app/views/user_mailer/confirmation.htmlerb",
    "generators/clearance/templates/app/views/users/_form.htmlerb",
    "generators/clearance/templates/app/views/users/edit.htmlerb",
    "generators/clearance/templates/app/views/users/new.htmlerb",
    "generators/clearance/templates/test/functional/confirmations_controller.rb",
    "generators/clearance/templates/test/functional/passwords_controller.rb",
    "generators/clearance/templates/test/functional/sessions_controller.rb",
    "generators/clearance/templates/test/functional/users_controller_test.rb",
    "generators/clearance/templates/test/unit/user_mailer_test.rb",
    "generators/clearance/templates/test/unit/user_test.rb",
    "generators/clearance/USAGE",
    "lib/clearance.rb",
    "lib/clearance/app/controllers/application_controller.rb",
    "lib/clearance/app/controllers/confirmations_controller.rb",
    "lib/clearance/app/controllers/passwords_controller.rb",
    "lib/clearance/app/controllers/sessions_controller.rb",
    "lib/clearance/app/controllers/users_controller.rb",
    "lib/clearance/app/models/user.rb",
    "lib/clearance/app/models/user_mailer.rb",
    "lib/clearance/test/functionals/confirmations_controller_test.rb",
    "lib/clearance/test/functionals/passwords_controller_test.rb",
    "lib/clearance/test/functionals/sessions_controller_test.rb",
    "lib/clearance/test/functionals/users_controller_test.rb",
    "lib/clearance/test/test_helper.rb",
    "lib/clearance/test/units/user_mailer_test.rb"
    "lib/clearance/test/units/user_test.rb"]
end
