Clearance
=========

Rails authentication & authorization with email & password.

[We have clearance, Clarence.](http://www.youtube.com/watch?v=fVq4_HhBK8Y)

Clearance was extracted out of [Hoptoad](http://hoptoadapp.com).

Help
----

* [Documentation](http://rdoc.info/gems/clearance) at RDoc.info.
* [Patches and bugs](http://github.com/thoughtbot/clearance/issues) at Github Issues.
* [Mailing list](http://groups.google.com/group/thoughtbot-clearance) at Google Groups.

Installation
------------

Clearance is a Rails engine for Rails 3. It is currently tested against Rails 3.0.9 and Rails 3.1.0.rc4.

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

Overriding defaults
-------------------

Clearance is intended to be small, simple, well-tested, and easy to override defaults.

If you ever need to change the logic in any of the four provided controllers,
subclass the Clearance controller. You don't need to do this by default.

    class SessionsController < Clearance::SessionsController
      def new
        # my special new action
      end

      def url_after_create
        my_special_path
      end
    end

and add your route in config/routes.rb:

    resource :session, :controller => 'sessions'

See config/routes.rb for all the routes Clearance provides.

Actions that redirect (create, update, and destroy) in Clearance controllers
can be overridden by re-defining url\_after\_(action) methods as seen above.

Clearance is an engine, so it provides views for you. If you want to customize those views, there is a handy shortcut to copy the views into your app:

    rails generate clearance:views

Optional Cucumber features
--------------------------

Clearance's Cucumber features are dependant on:

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

Optional test matchers
----------------------

Clearance comes with test matchers that are compatible with RSpec and Test::Unit.

To use them, require the test matchers. For example, in spec/support/clearance.rb:

    require 'clearance/testing'

You'll then have access to methods like:

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
