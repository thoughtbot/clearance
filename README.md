Clearance
=========

Rails authentication with email & password.

[We have clearance, Clarence.](http://www.youtube.com/watch?v=fVq4_HhBK8Y)

Clearance was extracted out of [Hoptoad](http://hoptoadapp.com).

Help
----

* [Documentation](http://rdoc.info/gems/clearance) at RDoc.info.
* [Patches welcome](http://github.com/thoughtbot/clearance/issues) via Github Issues.
* [#thoughtbot](irc://irc.freenode.net/thoughtbot) IRC channel on freenode.
* [Mailing list](http://groups.google.com/group/thoughtbot-clearance) on Google Groups.

Installation
------------

Clearance is a Rails engine for Rails 3.

Include the gem in your Gemfile:

    gem "clearance"

Make sure the development database exists, then run the generator:

    rails generate clearance:install

This:

* inserts Clearance::User into your User model
* inserts Clearance::Authentication into your ApplicationController
* creates a migration that either creates a users table or adds only missing columns

Use the [0.8.x](https://github.com/thoughtbot/clearance/tree/v0.8.8)
series of Clearance if you have a Rails 2 app.

Usage
-----

If you want to authenticate users for a controller action, use the authenticate
method in a before_filter.

    class WidgetsController < ApplicationController
      before_filter :authenticate
      def index
        @widgets = Widget.all
      end
    end

Customizing
-----------

To change any of provided actions, subclass a Clearance controller...

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
can be overridden by re-defining url_after_(action) methods as seen above.

Clearance is an engine, so it provides views for you. If you want to customize those views, there is a handy shortcut to copy the views into your app:

    rails generate clearance:views

Optional Cucumber features
--------------------------

As your app evolves, you want to know that authentication still works. If you
use [Cucumber](http://cukes.info), run the Clearance features generator:

    rails generate clearance:features

Edit your Gemfile to include:

    gem 'factory_girl_rails'

Edit config/enviroments/test.rb to include the following:

    config.action_mailer.default_url_options = { :host => 'localhost:3000' }

Then run your tests!

    rake

Extensions
----------

Clearance is intended to be small, simple, well-tested, and easy to extend.
Check out some of the ways people have extended Clearance:

* [Clearance HTTP Auth](https://github.com/karmi/clearance_http_auth)
* [Clearance Twitter](https://github.com/thoughtbot/clearance-twitter)
* [Clearance Admin](https://github.com/xenda/clearance-admin)

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Clearance is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

Thank you to all [the contributors](https://github.com/thoughtbot/clearance/contributors)!

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

Clearance is Copyright © 2009-2011 thoughtbot. It is free software, and may be redistributed under the terms specified in the LICENSE file.
