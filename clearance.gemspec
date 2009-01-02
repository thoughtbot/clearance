# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{clearance}
  s.version = "0.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["thoughtbot, inc.", "Josh Nichols", "Mike Breen"]
  s.date = %q{2009-01-02}
  s.description = %q{Simple, complete Rails authentication scheme.}
  s.email = %q{support@thoughtbot.com}
  s.files = ["LICENSE", "Rakefile", "README.textile", "TODO.textile", "generators/clearance", "generators/clearance/clearance_generator.rb", "generators/clearance/templates", "generators/clearance/templates/app", "generators/clearance/templates/app/controllers", "generators/clearance/templates/app/controllers/application.rb", "generators/clearance/templates/app/controllers/confirmations_controller.rb", "generators/clearance/templates/app/controllers/passwords_controller.rb", "generators/clearance/templates/app/controllers/sessions_controller.rb", "generators/clearance/templates/app/controllers/users_controller.rb", "generators/clearance/templates/app/models", "generators/clearance/templates/app/models/clearance_mailer.rb", "generators/clearance/templates/app/models/user.rb", "generators/clearance/templates/app/views", "generators/clearance/templates/app/views/clearance_mailer", "generators/clearance/templates/app/views/clearance_mailer/change_password.html.erb", "generators/clearance/templates/app/views/clearance_mailer/confirmation.html.erb", "generators/clearance/templates/app/views/confirmations", "generators/clearance/templates/app/views/confirmations/new.html.erb", "generators/clearance/templates/app/views/passwords", "generators/clearance/templates/app/views/passwords/edit.html.erb", "generators/clearance/templates/app/views/passwords/new.html.erb", "generators/clearance/templates/app/views/sessions", "generators/clearance/templates/app/views/sessions/new.html.erb", "generators/clearance/templates/app/views/users", "generators/clearance/templates/app/views/users/_form.html.erb", "generators/clearance/templates/app/views/users/edit.html.erb", "generators/clearance/templates/app/views/users/new.html.erb", "generators/clearance/templates/test", "generators/clearance/templates/test/factories.rb", "generators/clearance/templates/test/functional", "generators/clearance/templates/test/functional/confirmations_controller_test.rb", "generators/clearance/templates/test/functional/passwords_controller_test.rb", "generators/clearance/templates/test/functional/sessions_controller_test.rb", "generators/clearance/templates/test/functional/users_controller_test.rb", "generators/clearance/templates/test/unit", "generators/clearance/templates/test/unit/clearance_mailer_test.rb", "generators/clearance/templates/test/unit/user_test.rb", "generators/clearance/USAGE", "lib/clearance", "lib/clearance/app", "lib/clearance/app/controllers", "lib/clearance/app/controllers/application_controller.rb", "lib/clearance/app/controllers/confirmations_controller.rb", "lib/clearance/app/controllers/passwords_controller.rb", "lib/clearance/app/controllers/sessions_controller.rb", "lib/clearance/app/controllers/users_controller.rb", "lib/clearance/app/models", "lib/clearance/app/models/clearance_mailer.rb", "lib/clearance/app/models/user.rb", "lib/clearance/test", "lib/clearance/test/functional", "lib/clearance/test/functional/confirmations_controller_test.rb", "lib/clearance/test/functional/passwords_controller_test.rb", "lib/clearance/test/functional/sessions_controller_test.rb", "lib/clearance/test/functional/users_controller_test.rb", "lib/clearance/test/test_helper.rb", "lib/clearance/test/unit", "lib/clearance/test/unit/clearance_mailer_test.rb", "lib/clearance/test/unit/user_test.rb", "lib/clearance/version.rb", "lib/clearance.rb"]
  s.homepage = %q{http://github.com/thoughtbot/clearance}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple, complete Rails authentication.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
