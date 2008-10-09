Gem::Specification.new do |s|
  s.name = "clearance"
  s.version = "0.1.8"
  s.date = "2008-10-09"
  s.summary = "Simple, complete Rails authentication."
  s.email = "dcroak@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/clearance"
  s.description = "Simple, complete Rails authentication scheme."
  s.authors = ["thoughtbot, inc.", "Dan Croak", "Josh Nichols", "Mike Breen", "Mike Burns", "Jason Morrison"]
  s.files = ["README.textile",
    "clearance.gemspec",
    "lib/clearance.rb",
    "lib/clearance/app/controllers/application_controller.rb",
    "lib/clearance/app/models/model.rb",
    "lib/clearance/app/controllers/sessions_controller.rb",
    "lib/clearance/test/functionals/sessions_controller_test.rb",
    "lib/clearance/test/test_helper.rb",
    "lib/clearance/test/units/user_test.rb",
    "lib/clearance/app/controllers/users_controller.rb",
    "lib/clearance/test/functionals/users_controller_test.rb",
    "lib/clearance/app/controllers/passwords_controller.rb",
    "lib/clearance/test/functionals/passwords_controller_test.rb"]
end
