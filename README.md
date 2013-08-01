Clearance
=========

[![Build Status](https://secure.travis-ci.org/thoughtbot/clearance.png)](http://travis-ci.org/thoughtbot/clearance?branch=master)
[![Code Climate](https://codeclimate.com/github/thoughtbot/clearance.png)](https://codeclimate.com/github/thoughtbot/clearance)
[![Dependency Status](https://gemnasium.com/thoughtbot/clearance.png)](https://gemnasium.com/thoughtbot/clearance)

Rails authentication with email & password.

Clearance was extracted out of [Airbrake](http://airbrake.io/). It is intended
to be small, simple, well-tested, with easy to override defaults.

Use [Github Issues](https://github.com/thoughtbot/clearance/issues) for help.

Read [CONTRIBUTING.md](/CONTRIBUTING.md) to contribute.

Install
-------

Clearance is a Rails engine tested against Rails `>= 3.2` and Ruby `>= 1.9.3`.
It works with Rails 4 and Ruby 2.

Include the gem in your Gemfile:

```ruby
gem 'clearance', '1.0.0'
```

Bundle:

    bundle --binstubs

Make sure the development database exists. Then, run the generator:

    rails generate clearance:install

The generator:

* inserts `Clearance::User` into your `User` model
* inserts `Clearance::Controller` into your `ApplicationController`
* creates a migration that either creates a users table or adds only missing
  columns

Then, follow the instructions output from the generator.

Use Clearance [0.8.8](https://github.com/thoughtbot/clearance/tree/v0.8.8)
series for Rails 2 apps.

Use [0.16.3](http://rubygems.org/gems/clearance/versions/0.16.3) for Ruby 1.8.7.

Configure
---------

Override any of these defaults in `config/initializers/clearance.rb`:

```ruby
Clearance.configure do |config|
  config.cookie_expiration = lambda { 1.year.from_now.utc }
  config.httponly = false
  config.mailer_sender = 'reply@example.com'
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  config.redirect_url = '/'
  config.secure_cookie = false
  config.user_model = User
end
```

Use
---

Use `current_user`, `signed_in?`, and `signed_out?` in controllers, views, and
helpers. For example:

```haml
- if signed_in?
  = current_user.email
  = link_to 'Sign out', sign_out_path, method: :delete
- else
  = link_to 'Sign in', sign_in_path
```

To authenticate a user elsewhere than `sessions/new` (like in an API):

```ruby
User.authenticate 'email@example.com', 'password'
```

When a user resets their password, Clearance delivers them an email. So, you
should change the `mailer_sender` default, used in the email's "from" header:

```ruby
Clearance.configure do |config|
  config.mailer_sender = 'reply@example.com'
end
```

Use `authorize` to control access in controllers:

```ruby
class ArticlesController < ApplicationController
  before_filter :authorize

  def index
    current_user.articles
  end
end
```

Or, you can authorize users in `config/routes.rb`:

```ruby
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
```

Clearance adds its session to the Rack environment hash so middleware and other
Rack applications can interact with it:

```ruby
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
```

Overriding routes
-----------------

See [config/routes.rb](/config/routes.rb) for the default behavior.

To override a Clearance route, redefine it:

```ruby
resource :session, controller: 'sessions'
```

Overriding controllers
----------------------

See [app/controllers/clearance](/app/controllers/clearance) for the default
behavior.

To override a Clearance controller, subclass it:

```ruby
class PasswordsController < Clearance::PasswordsController
class SessionsController < Clearance::SessionsController
class UsersController < Clearance::UsersController
```

Then, override public methods:

    passwords#create
    passwords#edit
    passwords#new
    passwords#update
    sessions#create
    sessions#destroy
    sessions#new
    users#create
    users#new

Or, override private methods:

    passwords#find_user_by_id_and_confirmation_token
    passwords#find_user_for_create
    passwords#find_user_for_edit
    passwords#find_user_for_update
    passwords#flash_failure_after_create
    passwords#flash_failure_after_update
    passwords#flash_failure_when_forbidden
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

All of these controller methods redirect to `'/'` by default:

    passwords#url_after_update
    sessions#url_after_create
    users#url_after_create
    application#url_after_denied_access_when_signed_in

To override them all at once, change the global configuration:

```ruby
Clearance.configure do |config|
  config.redirect_url = '/overriden'
end
```

Overriding translations
-----------------------

All flash messages and email subject lines are stored in
[i18n translations](http://guides.rubyonrails.org/i18n.html).
Override them like any other translation.

See [config/locales/clearance.en.yml](/config/locales/clearance.en.yml) for the
default behavior.

Overriding views
----------------

See [app/views](/app/views) for the default behavior.

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

See [lib/clearance/user.rb](/lib/clearance/user.rb) for the default behavior.

To override the model, redefine public methods:

    User.authenticate(email, password)
    User#forgot_password!
    User#reset_remember_token!
    User#update_password(new_password)

Or, redefine private methods:

    User#email_optional?
    User#generate_confirmation_token
    User#generate_remember_token
    User#normalize_email
    User#password_optional?

Overriding the password strategy
--------------------------------

By default, Clearance uses BCrypt encryption of the user's password.

See
[lib/clearance/password_strategies/bcrypt.rb](/lib/clearance/password_strategies/bcrypt.rb)
for the default behavior.

Change your password strategy in `config/initializers/clearance.rb:`

```ruby
Clearance.configure do |config|
  config.password_strategy = Clearance::PasswordStrategies::SHA1
end
```

Clearance provides the following strategies:

```ruby
Clearance::PasswordStrategies::BCrypt
Clearance::PasswordStrategies::BCryptMigrationFromSHA1
Clearance::PasswordStrategies::Blowfish
Clearance::PasswordStrategies::SHA1
```

The previous default password strategy was SHA1.

Switching password strategies may cause your existing users to not be able to sign in.

If you have an existing app that used the old `SHA1` strategy and you want to
stay with SHA1, use
[Clearance::PasswordStrategies::SHA1](/lib/clearance/password_strategies/sha1.rb).

If you have an existing app that used the old `SHA1` strategy and you want to
switch to BCrypt transparently, use
[Clearance::PasswordStrategies::BCryptMigrationFromSHA1](/lib/clearance/password_strategies/bcrypt_migration_from_sha1.rb).

The SHA1 and Blowfish password strategies require an additional `salt` column in
the `users` table. Run this migration before switching to SHA or Blowfish:

```ruby
class AddSaltToUsers < ActiveRecord::Migration
  def change
    add_column :users, :salt, :string, limit: 128
  end
end
```

You can write a custom password strategy that has two instance methods:

```ruby
module CustomPasswordStrategy
  def authenticated?
  end

  def password=(new_password)
  end
end

Clearance.configure do |config|
  config.password_strategy = CustomPasswordStrategy
end
```

Deliver password reset email in a background job
------------------------------------------------

Clearance has one mailer. It is used to reset the user's password.

To deliver it in a background job using a queue system like [Delayed
Job](https://github.com/collectiveidea/delayed_job), subclass
`Clearance::PasswordsController` and define the behavior you need in its
`deliver_email` method:

```ruby
class PasswordsController < Clearance::PasswordsController
  def deliver_email(user)
    ClearanceMailer.delay.change_password(user)
  end
end
```

Then, override the route:

```ruby
resources :passwords, only: [:create]
```

Optional feature specs
----------------------

You can generate feature specs to help prevent regressions in Clearance's
integration with your Rails app over time.

Edit your `Gemfile` to include the dependencies:

```ruby
gem 'capybara', '~> 2.0'
gem 'factory_girl_rails', '~> 4.2'
gem 'rspec-rails', '~> 2.13'
```

Generate RSpec files:

    rails generate rspec:install

Generate Clearance specs:

    rails generate clearance:specs

Run the specs:

    rake

Testing authorized controller actions
-------------------------------------

To test controller actions that are protected by `before_filter :authorize`,
include Clearance's test helpers and matchers in `spec/support/clearance.rb` or
`test/test_helper.rb`:

```ruby
require 'clearance/testing'
```

This will make `Clearance::Controller` methods work in your controllers
during functional tests and provide access to helper methods like:

    sign_in
    sign_in_as(user)
    sign_out

And matchers like:

    deny_access

Example:

```ruby
context 'a guest' do
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
```

You may want to customize the tests:

```ruby
it { should deny_access  }
it { should deny_access(flash: 'Denied access.')  }
it { should deny_access(redirect: sign_in_url)  }
```

Faster tests
------------

Clearance includes middleware that avoids wasting time spent visiting, loading,
and submitting the sign in form. It instead signs in the designated
user directly. The speed increase can be
[substantial](http://robots.thoughtbot.com/post/37907699673/faster-tests-sign-in-through-the-back-door).

Configuration:

```ruby
# config/environments/test.rb
MyRailsApp::Application.configure do
  # ...
  config.middleware.use Clearance::BackDoor
  # ...
end
```

Usage:

```ruby
visit root_path(as: user)
```

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Clearance is maintained by [thoughtbot, inc](http://thoughtbot.com/community)
and [contributors](/thoughtbot/clearance/graphs/contributors) like you. Thank you!

License
-------

Clearance is copyright © 2009-2013 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
