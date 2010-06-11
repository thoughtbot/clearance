Clearance
=========

Rails authentication with email & password.

[We have clearance, Clarence.](http://www.youtube.com/watch?v=fVq4_HhBK8Y)

Help
----

* [documentation](http://rdoc.info/projects/thoughtbot/clearance)
* [#thoughtbot](irc://irc.freenode.net/thoughtbot) IRC channel on freenode
* [mailing list](http://groups.google.com/group/thoughtbot-clearance)

Bugs, Patches
-------------

Fork away and create a [Github Issue](http://github.com/thoughtbot/clearance/issues).

Installation
------------

Clearance is a Rails engine. The latest stable version works with versions of Rails greater than 3.  If you need to run on Rails 2.x, install Clearance Version 0.8.8.

Install it as a gem however you like to install gems. Also, uninstall old versions:

    sudo gem uninstall thoughtbot-clearance
    sudo gem uninstall clearance
    sudo gem install clearance

Make sure the development database exists, then run the generator:

    script/rails generate clearance

This:

* inserts Clearance::User into your User model
* inserts Clearance::Authentication into your ApplicationController
* created a migration that either creates a users table or adds only missing columns

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
can be overriden by re-defining url_after_(action) methods as seen above.

Optional Cucumber features
--------------------------

As your app evolves, you want to know that authentication still works. Our
opinion is that you should test its integration with your app using
[Cucumber](http://cukes.info).

Run the Cucumber generator and Clearance feature generator:

    script/rails generate cucumber
    script/rails generate clearance_features

Edit your Gemfile to include:

    gem 'factory_girl'

Edit your config/enviroments/cucumber.rb to include the following:

    ActionMailer::Base.default_url_options = { :host => 'localhost:3000' }

Then run rake!

Optional Formtastic views
-------------------------

We use & recommend [Formtastic](http://github.com/justinfrench/formtastic).

Clearance has another generator to generate Formastic views:

    script/rails generate clearance_views

Its implementation is designed so other view styles (Haml?) can be generated.

Authors
-------

Clearance was extracted out of [Hoptoad](http://hoptoadapp.com). We merged the
authentication code from two of thoughtbot client Rails apps and have since
used it each time we need authentication.

The following people have improved the library. Thank you!

Dan Croak, Mike Burns, Jason Morrison, Joe Ferris, Eugene Bolshakov,
Nick Quaranto, Josh Nichols, Mike Breen, Marcel Görner, Bence Nagy, Ben Mabey,
Eloy Duran, Tim Pope, Mihai Anca, Mark Cornick, Shay Arnett, Joshua Clayton,
Mustafa Ekim, Jon Yurek, Anuj Dutta, Chad Pytel, Ben Orenstein, Bobby Wilson,
Matthew Ford, Ryan McGeary, Claudio Poli, Joseph Holsten, Peter Haza,
Ron Newman, and Rich Thornett.
