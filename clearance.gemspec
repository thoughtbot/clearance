--- !ruby/object:Gem::Specification 
name: clearance
version: !ruby/object:Gem::Version 
  version: 0.6.9
platform: ruby
authors: 
- Dan Croak
- Mike Burns
- Jason Morrison
- Joe Ferris
- Eugene Bolshakov
- Nick Quaranto
- Josh Nichols
- Mike Breen
- "Marcel G\xC3\xB6rner"
- Bence Nagy
- Ben Mabey
- Eloy Duran
- Tim Pope
- Mihai Anca
- Mark Cornick
- Shay Arnett
autorequire: 
bindir: bin
cert_chain: []

date: 2009-07-04 00:00:00 -04:00
default_executable: 
dependencies: []

description: Rails authentication with email & password.
email: support@thoughtbot.com
executables: []

extensions: []

extra_rdoc_files: []

files: 
- CHANGELOG.textile
- LICENSE
- Rakefile
- README.textile
- TODO.textile
- app/controllers
- app/controllers/clearance
- app/controllers/clearance/confirmations_controller.rb
- app/controllers/clearance/passwords_controller.rb
- app/controllers/clearance/sessions_controller.rb
- app/controllers/clearance/users_controller.rb
- app/models
- app/models/clearance_mailer.rb
- app/views
- app/views/clearance_mailer
- app/views/clearance_mailer/change_password.html.erb
- app/views/clearance_mailer/confirmation.html.erb
- app/views/passwords
- app/views/passwords/edit.html.erb
- app/views/passwords/new.html.erb
- app/views/sessions
- app/views/sessions/new.html.erb
- app/views/users
- app/views/users/_form.html.erb
- app/views/users/new.html.erb
- config/clearance_routes.rb
- generators/clearance
- generators/clearance/clearance_generator.rb
- generators/clearance/lib
- generators/clearance/lib/insert_commands.rb
- generators/clearance/lib/rake_commands.rb
- generators/clearance/templates
- generators/clearance/templates/factories.rb
- generators/clearance/templates/migrations
- generators/clearance/templates/migrations/create_users.rb
- generators/clearance/templates/migrations/update_users.rb
- generators/clearance/templates/README
- generators/clearance/templates/user.rb
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
- lib/clearance/authentication.rb
- lib/clearance/extensions
- lib/clearance/extensions/errors.rb
- lib/clearance/extensions/rescue.rb
- lib/clearance/extensions/routes.rb
- lib/clearance/user.rb
- lib/clearance.rb
- shoulda_macros/clearance.rb
- rails/init.rb
has_rdoc: true
homepage: http://github.com/thoughtbot/clearance
licenses: []

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
rubygems_version: 1.3.4
signing_key: 
specification_version: 3
summary: Rails authentication with email & password.
test_files: []

