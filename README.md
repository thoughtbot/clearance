Clearance
=========

Rails authentication with email & password.

[We have clearance, Clarence.](http://www.youtube.com/v/mNRXJEE3Nz8)

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

Clearance is a Rails engine. It works with versions of Rails greater than 2.3.

Install it as a gem however you like to install gems. Gem Bundler example:

    gem "clearance"

Make sure the development database exists and run the generator:

    script/generate clearance

This:

* inserts Clearance::User into your User model
* inserts Clearance::Authentication into your ApplicationController
* inserts Clearance::Routes.draw(map) into your config.routes.rb
* created a migration that either creates a users table or adds only missing columns
* prints further instructions

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

and add your route above (before) Clearance routes in config/routes.rb:

    map.resource :session, :controller => 'sessions'

See lib/clearance/routes.rb for all the routes Clearance provides.

Actions that redirect (create, update, and destroy) in Clearance controllers
can be overriden by re-defining url_after_(action) methods as seen above.

Optional Cucumber features
--------------------------

As your app evolves, you want to know that authentication still works. Our
opinion is that you should test its integration with your app using
[Cucumber](http://cukes.info).

Run the Cucumber generator and Clearance feature generator:

    script/generate cucumber
    script/generate clearance_features

All of the files generated should be new with the exception of the
features/support/paths.rb file. If you have not modified your paths.rb then you
will be okay to replace it with this one. If you need to keep your paths.rb
file then add these locations in your paths.rb manually:

  def path_to(page_name)
    case page_name
    when /the sign up page/i
     new_user_path
    when /the sign in page/i
     new_session_path
    when /the password reset request page/i
     new_password_path
    end
  end

Optional Formtastic views
-------------------------

We use & recommend [Formtastic](http://github.com/justinfrench/formtastic].

Clearance has another generator to generate Formastic views:

    script/generate clearance_views

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
Matthew Ford, Ryan McGeary, Claudio Poli, Joseph Holsten, and Peter Haza.
