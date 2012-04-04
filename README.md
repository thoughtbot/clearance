Clearance [![Build Status](https://secure.travis-ci.org/thoughtbot/clearance.png)](http://travis-ci.org/thoughtbot/clearance?branch=master)
=========

Rails authentication & authorization with email & password.

[We have clearance, Clarence.](http://www.youtube.com/watch?v=fVq4_HhBK8Y)

Clearance was extracted out of [Airbrake](http://airbrakeapp.com/).

Help
----

* [Documentation](http://rdoc.info/gems/clearance) at RDoc.info.
* [Patches and bugs](http://github.com/thoughtbot/clearance/issues) at Github Issues.
* [Mailing list](http://groups.google.com/group/thoughtbot-clearance) at Google Groups.

Installation
------------

Clearance is a Rails engine for Rails 3. It is currently tested against Rails 3.0.12 and Rails 3.1.4.

Include the gem in your Gemfile:

    gem "clearance"

Make sure the development database exists, then run the generator:

    rails generate clearance:install

This:

* inserts Clearance::User into your User model
* inserts Clearance::Authentication into your ApplicationController
* creates a migration that either creates a users table or adds only missing columns

Follow the instructions that are output from the generator.

Use the [0.8.x](https://github.com/thoughtbot/clearance/tree/v0.8.8)
series of Clearance if you have a Rails 2 app.

Usage
-----

If you want to authorize users for a controller action, use the authorize
method in a before_filter.

    class WidgetsController < ApplicationController
      before_filter :authorize

      def index
        @widgets = Widget.all
      end
    end

If you want to reference the current user in a controller, view, or helper, use
the current_user method.

    def index
      current_user.articles
    end

If you want to know whether the current user is signed in or out, you can use
these methods in controllers, views, or helpers:

    signed_in?
    signed_out?

Typically, you want to have something like this in your app, maybe in a layout:

    <% if signed_in? %>
      <%= current_user.email %>
      <%= link_to "Sign out", sign_out_path, :method => :delete %>
    <% else %>
      <%= link_to "Sign in", sign_in_path %>
    <% end %>

If you ever want to authenticate the user some place other than sessions/new,
maybe in an API:

    User.authenticate("email@example.com", "password")

Clearance will deliver one email on your app's behalf: when a user resets their password. Therefore, you should change the default email address that email comes from:

    # config/initializers/clearance.rb
    Clearance.configure do |config|
      config.mailer_sender = "me@example.com"
    end

Rack
----

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


Overriding defaults
-------------------

Clearance is intended to be small, simple, well-tested, and easy to override defaults.

Overriding routes
-----------------

See [config/routes.rb](https://github.com/thoughtbot/clearance/blob/master/config/routes.rb) for the default behavior.

To override a Clearance route, redefine it:

    resource :session, :controller => 'sessions'

Overriding controllers
----------------------

See [app/controllers/clearance](https://github.com/thoughtbot/clearance/tree/master/app/controllers/clearance) for the default behavior.

To override a Clearance controller, subclass it:

    class SessionsController < Clearance::SessionsController
      def new
        # my special new action
      end

      def url_after_create
        my_special_path
      end
    end

You may want to override entire actions:

    def new
    end

Or, you may want to override private methods that actions use:

    url_after_create
    url_after_update
    url_after_destroy
    flash_failure_after_create
    flash_failure_after_update
    flash_failure_when_forbidden
    forbid_missing_token
    forbid_non_existent_user

Overriding translations
-----------------------

All flash messages and email subject lines are stored in [i18n translations](http://guides.rubyonrails.org/i18n.html). Override them like any other translation.

Overriding views
----------------

See [app/views](https://github.com/thoughtbot/clearance/tree/master/app/views) for the default behavior.

To override those **views**, create them in your own `app/views` directory.

There is a shortcut to copy all Clearance views into your app:

    rails generate clearance:views

Overriding the model
--------------------

If you want to override the **model** behavior, you can include sub-modules of `Clearance::User`:

    extend  Clearance::User::ClassMethods
    include Clearance::User::Validations
    include Clearance::User::Callbacks

`ClassMethods` contains the `User.authenticate(email, password)` method.

`Validations` contains validations for email and password.

`Callbacks` contains `ActiveRecord` callbacks downcasing the email and generating a remember token.

Overriding the password strategy
--------------------------------

By default, Clearance uses SHA1 encryption of the user's password. You can provide your own password strategy by creating a module that conforms to an API of two instance methods:

    def authenticated?
    end

    def encrypt_password
    end

See [lib/clearance/password_strategies/sha1.rb](https://github.com/thoughtbot/clearance/blob/master/lib/clearance/password_strategies/sha1.rb) for the default behavior. Also see [lib/clearance/password_strategies/blowfish.rb](https://github.com/thoughtbot/clearance/blob/master/lib/clearance/password_strategies/blowfish.rb) for another password strategy. Switching password strategies will cause your existing users' passwords to not work.

Once you have an API-compliant module, load it with:

    Clearance.configure do |config|
      config.password_strategy = MyPasswordStrategy
    end

For example:

    # default
    config.password_strategy = Clearance::PasswordStrategies::SHA1
    # Blowfish
    config.password_strategy = Clearance::PasswordStrategies::Blowfish
    

Optional Cucumber features
--------------------------

Clearance's Cucumber features are dependent on:

* Cucumber
* Capybara
* RSpec
* Factory Girl

As your app evolves, you want to know that authentication still works. If you've
installed [Cucumber](http://cukes.info) into your app:

    rails generate cucumber:install

Then, you can use the Clearance features generator:

    rails generate clearance:features

Edit your Gemfile to include:

    gem 'factory_girl_rails'

Edit config/enviroments/test.rb to include the following:

    config.action_mailer.default_url_options = { :host => 'localhost:3000' }

Then run your tests!

    rake

Testing
-------

If you want to write Rails functional tests or controller specs with Clearance,
you'll need to require the  included test helpers and matchers.

For example, in spec/support/clearance.rb or test/test_helper.rb:

    require 'clearance/testing'

This will make Clearance::Authentication methods work in your controllers
during functional tests and provide access to helper methods like:

    sign_in
    sign_in_as(user)
    sign_out

And matchers like:

    deny_access

Example:

    context "a visitor" do
      before { get :show }
      it     { should deny_access }
    end

    context "a user" do
      before do
        sign_in
        get :show
      end

      it { should respond_with(:success) }
    end

Contributing
------------

Please see CONTRIBUTING.md for details.

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Clearance is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

Thank you to all [the contributors](https://github.com/thoughtbot/clearance/contributors)!

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

Clearance is Copyright © 2009-2011 thoughtbot. It is free software, and may be redistributed under the terms specified in the LICENSE file.
