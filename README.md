Clearance
=========

[![Build Status](https://secure.travis-ci.org/thoughtbot/clearance.png)](http://travis-ci.org/thoughtbot/clearance?branch=master)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/thoughtbot/clearance)

Rails authentication with email & password.

Clearance was extracted out of [Airbrake](http://airbrake.io/).
It is intended to be small, simple, well-tested, and easy to override defaults.

Use [Github Issues](/thoughtbot/clearance/issues) for help.

Read [CONTRIBUTING.md](/thoughtbot/clearance/blob/master/CONTRIBUTING.md) to contribute.

Install
-------

Clearance is a Rails engine tested against
[Rails 3.x](/thoughtbot/clearance/blob/master/Appraisals) on Ruby 1.9.x.

Include the gem in your Gemfile:

    gem 'clearance', '1.0.0.rc2'

Bundle:

    bundle --binstubs

Make sure the development database exists. Then, run the generator:

    rails generate clearance:install

The generator:

* inserts Clearance::User into your User model
* inserts Clearance::Authentication into your ApplicationController
* creates a migration that either creates a users table or adds only missing columns

Then, follow the instructions output from the generator.

Use the [0.8.x](/thoughtbot/clearance/tree/v0.8.8) series for Rails 2 apps.

Use [0.16.3](http://rubygems.org/gems/clearance/versions/0.16.3) for Ruby 1.8.7.

Configure
---------

Override any of the defaults in `config/initializers/clearance.rb`:

    Clearance.configure do |config|
      config.cookie_expiration = lambda { 1.year.from_now.utc }
      config.mailer_sender = 'reply@example.com'
      config.password_strategy = Clearance::PasswordStrategies::BCrypt
      config.user_model = User
    end

Use
---

Use `current_user`, `signed_in?`, and `signed_out?` in controllers, views, and
helpers. For example:

    - if signed_in?
      = current_user.email
      = link_to 'Sign out', sign_out_path, method: :delete
    - else
      = link_to 'Sign in', sign_in_path

To authenticate a user elsewhere than `sessions/new` (like in an API):

    User.authenticate 'email@example.com', 'password'

When a user resets their password, Clearance delivers them an email. So, you
should change the `mailer_sender` default, used in the email's "from" header:

    Clearance.configure do |config|
      config.mailer_sender = 'reply@example.com'
    end

Use `authorize` to control access in controllers:

    class ArticlesController < ApplicationController
      before_filter :authorize

      def index
        current_user.articles
      end
    end

Or, you can authorize users in `config/routes.rb`:

    Blog::Application.routes.draw do
      constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
        root to: 'admin'
      end

      constraints Clearance::Constraints::SignedIn.new do
        root to: 'dashboard'
      end

      constraints Clearance::Constraints::SignedOut.new do
        root to: 'marketing'
      end
    end

Clearance adds its session to the Rack environment hash so middleware and other
Rack applications can interact with it:

    class Bubblegum::Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        if env[:clearance].signed_in?
          env[:clearance].current_user.bubble_gum
        end

        @app.call(env)
      end
    end

Overriding routes
-----------------

See [config/routes.rb](/thoughtbot/clearance/blob/master/config/routes.rb) for
the default behavior.

To override a Clearance route, redefine it:

    resource :session, controller: 'sessions'

Overriding controllers
----------------------

See [app/controllers/clearance](/thoughtbot/clearance/tree/master/app/controllers/clearance)
for the default behavior.

To override a Clearance controller, subclass it:

    class PasswordsController < Clearance::PasswordsController
    class SessionsController < Clearance::SessionsController
    class UsersController < Clearance::UsersController

Then, override public methods:

    passwords#create
    passwords#edit
    passwords#new
    passwords#update
    sessions#create
    sessions#destroy
    sessions#new
    users#new
    users#create

Or, override private methods:

    passwords#find_user_by_id_and_confirmation_token
    passwords#find_user_for_create
    passwords#find_user_for_edit
    passwords#find_user_for_update
    passwords#flash_failure_when_forbidden
    passwords#flash_failure_after_create
    passwords#flash_failure_after_update
    passwords#forbid_missing_token
    passwords#forbid_non_existent_user
    passwords#url_after_create
    passwords#url_after_update
    sessions#flash_failure_after_create
    sessions#url_after_create
    sessions#url_after_destroy
    users#flash_failure_after_create
    users#url_after_create
    users#user_from_params

Overriding translations
-----------------------

All flash messages and email subject lines are stored in
[i18n translations](http://guides.rubyonrails.org/i18n.html).
Override them like any other translation.

Overriding views
----------------

See [app/views](/thoughtbot/clearance/tree/master/app/views) for the default
behavior.

To override a view, create your own:

    app/views/clearance_mailer/change_password.html.erb
    app/views/passwords/create.html.erb
    app/views/passwords/edit.html.erb
    app/views/passwords/new.html.erb
    app/views/sessions/_form.html.erb
    app/views/sessions/new.html.erb
    app/views/users/_form.html.erb
    app/views/users/new.html.erb

There is a shortcut to copy all Clearance views into your app:

    rails generate clearance:views

Overriding the model
--------------------

See [lib/clearance/user.rb](/thoughtbot/clearance/tree/master/lib/clearance/user.rb)
for the default behavior.

To override the model, redefine public methods:

    .authenticate(email, password)
    #forgot_password!
    #reset_remember_token!
    #update_password(new_password)

Or, redefine private methods:

    #downcase_email
    #email_optional?
    #generate_confirmation_token
    #generate_remember_token
    #password_optional?

Overriding the password strategy
--------------------------------

By default, Clearance uses BCrypt encryption of the user's password.

See [lib/clearance/password_strategies/bcrypt.rb](/thoughtbot/clearance/blob/master/lib/clearance/password_strategies/bcrypt.rb)
for the default behavior.

Change your password strategy in `config/initializers/clearance.rb:`

    Clearance.configure do |config|
      config.password_strategy = Clearance::PasswordStrategies::SHA1
    end

Clearance provides the following strategies:

    config.password_strategy = Clearance::PasswordStrategies::BCrypt
    config.password_strategy = Clearance::PasswordStrategies::BCryptMigrationFromSHA1
    config.password_strategy = Clearance::PasswordStrategies::Blowfish
    config.password_strategy = Clearance::PasswordStrategies::SHA1

The previous default password strategy was SHA1.

Switching password strategies may cause your existing users to not be able to sign in.

If you have an existing app that used the old `SHA1` strategy and you
want to stay with SHA1, use
[Clearance::PasswordStrategies::SHA1](/thoughtbot/clearance/blob/master/lib/clearance/password_strategies/sha1.rb).

If you have an existing app that used the old `SHA1` strategy and you
want to switch to BCrypt transparently, use
[Clearance::PasswordStrategies::BCryptMigrationFromSHA1](/thoughtbot/clearance/blob/master/lib/clearance/password_strategies/bcrypt_migration_from_sha1.rb).

The SHA1 and Blowfish password strategies require an additional `salt` column in
the `users` table. Run this migration before switching to SHA or Blowfish:

    class AddSaltToUsers < ActiveRecord::Migration
      def change
        add_column :users, :salt, :string, :limit => 128
      end
    end

You can write a custom password strategy that has two instance methods:

    module CustomPasswordStrategy
      def authenticated?
      end

      def password=(new_password)
      end
    end

    Clearance.configure do |config|
      config.password_strategy = CustomPasswordStrategy
    end

Optional Integration tests
--------------------------

Clearance's integration tests are dependent on:

* Capybara
* RSpec
* Factory Girl

As your app evolves, you want to know that authentication still works. We include support for RSpec integration tests.

If you've installed [RSpec](https://github.com/rspec/rspec) in your app:

    rails generate rspec:install

Then, you can use the Clearance specs generator:

    rails generate clearance:specs

Edit your Gemfile to include:

    gem 'factory_girl_rails'

Edit `config/enviroments/test.rb` to include the following:

    config.action_mailer.default_url_options = { host: 'localhost:3000' }

Then run your tests!

    rake

Testing
-------

If you want to write Rails functional tests or controller specs with Clearance,
you'll need to require the included test helpers and matchers.

For example, in `spec/support/clearance.rb` or `test/test_helper.rb`:

    require 'clearance/testing'

This will make `Clearance::Authentication` methods work in your controllers
during functional tests and provide access to helper methods like:

    sign_in
    sign_in_as(user)
    sign_out

And matchers like:

    deny_access

Example:

    context 'a visitor' do
      before do
        get :show
      end

      it { should deny_access }
    end

    context 'a user' do
      before do
        sign_in
        get :show
      end

      it { should respond_with(:success) }
    end

You may want to customize the tests:

    it { should deny_access  }
    it { should deny_access(flash: 'Denied access.')  }
    it { should deny_access(redirect: sign_in_url)  }

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Clearance is maintained by [thoughtbot, inc](http://thoughtbot.com/community)
and [contributors](/thoughtbot/clearance/contributors) like you. Thank you!

License
-------

Clearance is copyright © 2009-2012 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
