--- !ruby/object:Gem::Specification 
name: clearance
version: !ruby/object:Gem::Version 
  version: 0.5.4
platform: ruby
authors: 
- thoughtbot, inc.
- Dan Croak
- Mike Burns
- Jason Morrison
- Eugene Bolshakov
- Josh Nichols
- Mike Breen
- Joe Ferris
- Bence Nagy
- "Marcel G\xC3\xB6rner"
- Ben Mabey
- Tim Pope
- Eloy Duran
- Mihai Anca
- Mark Cornick
autorequire: 
bindir: bin
cert_chain: []

date: 2009-03-05 00:00:00 -05:00
default_executable: 
dependencies: []

description: Simple, complete Rails authentication scheme.
email: support@thoughtbot.com
executables: []

extensions: []

extra_rdoc_files: []

files: 
- CHANGELOG.textile
- KNOWN_ISSUES.textile
- LICENSE
- Rakefile
- README.textile
- generators/clearance
- generators/clearance/clearance_generator.rb
- generators/clearance/lib
- generators/clearance/lib/insert_commands.rb
- generators/clearance/lib/rake_commands.rb
- generators/clearance/templates
- generators/clearance/templates/app
- generators/clearance/templates/app/controllers
- generators/clearance/templates/app/controllers/application.rb
- generators/clearance/templates/app/controllers/confirmations_controller.rb
- generators/clearance/templates/app/controllers/passwords_controller.rb
- generators/clearance/templates/app/controllers/sessions_controller.rb
- generators/clearance/templates/app/controllers/users_controller.rb
- generators/clearance/templates/app/models
- generators/clearance/templates/app/models/clearance_mailer.rb
- generators/clearance/templates/app/models/user.rb
- generators/clearance/templates/app/views
- generators/clearance/templates/app/views/clearance_mailer
- generators/clearance/templates/app/views/clearance_mailer/change_password.html.erb
- generators/clearance/templates/app/views/clearance_mailer/confirmation.html.erb
- generators/clearance/templates/app/views/passwords
- generators/clearance/templates/app/views/passwords/edit.html.erb
- generators/clearance/templates/app/views/passwords/new.html.erb
- generators/clearance/templates/app/views/sessions
- generators/clearance/templates/app/views/sessions/new.html.erb
- generators/clearance/templates/app/views/users
- generators/clearance/templates/app/views/users/_form.html.erb
- generators/clearance/templates/app/views/users/edit.html.erb
- generators/clearance/templates/app/views/users/new.html.erb
- generators/clearance/templates/db
- generators/clearance/templates/db/migrate
- generators/clearance/templates/db/migrate/create_users_with_clearance_columns.rb
- generators/clearance/templates/db/migrate/update_users_with_clearance_columns.rb
- generators/clearance/templates/README
- generators/clearance/templates/test
- generators/clearance/templates/test/factories
- generators/clearance/templates/test/factories/clearance.rb
- generators/clearance/templates/test/functional
- generators/clearance/templates/test/functional/confirmations_controller_test.rb
- generators/clearance/templates/test/functional/passwords_controller_test.rb
- generators/clearance/templates/test/functional/sessions_controller_test.rb
- generators/clearance/templates/test/functional/users_controller_test.rb
- generators/clearance/templates/test/unit
- generators/clearance/templates/test/unit/clearance_mailer_test.rb
- generators/clearance/templates/test/unit/user_test.rb
- generators/clearance/USAGE
- generators/clearance_features
- generators/clearance_features/clearance_features_generator.rb
- generators/clearance_features/templates
- generators/clearance_features/templates/features
- generators/clearance_features/templates/features/password_reset.feature
- generators/clearance_features/templates/features/sign_in.feature
- generators/clearance_features/templates/features/sign_out.feature
- generators/clearance_features/templates/features/sign_up.feature
- generators/clearance_features/templates/features/step_definitions
- generators/clearance_features/templates/features/step_definitions/clearance_steps.rb
- generators/clearance_features/templates/features/step_definitions/factory_girl_steps.rb
- generators/clearance_features/templates/features/support
- generators/clearance_features/templates/features/support/paths.rb
- generators/clearance_features/USAGE
- lib/clearance
- lib/clearance/app
- lib/clearance/app/controllers
- lib/clearance/app/controllers/application_controller.rb
- lib/clearance/app/controllers/confirmations_controller.rb
- lib/clearance/app/controllers/passwords_controller.rb
- lib/clearance/app/controllers/sessions_controller.rb
- lib/clearance/app/controllers/users_controller.rb
- lib/clearance/app/models
- lib/clearance/app/models/clearance_mailer.rb
- lib/clearance/app/models/user.rb
- lib/clearance/lib
- lib/clearance/lib/extensions
- lib/clearance/lib/extensions/errors.rb
- lib/clearance/lib/extensions/rescue.rb
- lib/clearance/test
- lib/clearance/test/functional
- lib/clearance/test/functional/confirmations_controller_test.rb
- lib/clearance/test/functional/passwords_controller_test.rb
- lib/clearance/test/functional/sessions_controller_test.rb
- lib/clearance/test/functional/users_controller_test.rb
- lib/clearance/test/unit
- lib/clearance/test/unit/clearance_mailer_test.rb
- lib/clearance/test/unit/user_test.rb
- lib/clearance.rb
- shoulda_macros/clearance.rb
- rails/init.rb
has_rdoc: false
homepage: http://github.com/thoughtbot/clearance
post_install_message: 
rdoc_options: []

require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.3.1
signing_key: 
specification_version: 2
summary: Rails authentication for developers who write tests.
test_files: []

