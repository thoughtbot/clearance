New for 1.0.0:

* Change default password strategy to BCrypt.
* Provide BCryptMigrationFromSHA1 password strategy to help people migrate from
  SHA1 (the old default password strategy) to BCrypt (the new default).
* Require > Ruby 1.9.
* A revamped, more descriptive README.
* More extension points in more controllers.
* The email, encrypted_password, and remember_token fields of the users
  table are NOT NULL in the default migration.
* We support Test::Unit.
* Drop Rails plugin support.
* Add SignedIn and SignedOut routing constraints.
* Add a fake password strategy, which is useful when writing tests.
* Remove deprecated methods on User: remember_me!, generate_random_code,
  password_required?.
* Improve security when changing password.
* Replace Cucumber feature generator with RSpec + Capybara.
* Remove Diesel dependency.
* Add locales support.
* PasswordsController `params[:user]` has changed to `params[:password_reset]` to avoid locale conflicts

New for 0.16.2:

* Change default email sender to deploy@example.com .

New for 0.16.1:

* Behave correctly when Rails whitelist attributes mass assignment
  protection is turned on
* Fix for Rails 3.2.x modifying the HTTP cookie headers in rack requests

New for 0.16.0:

* Blowfish password encryption strategy (Chris Dillon)

New for 0.15.0:

* The User model can be swapped out using the Clearance.configure method.
* Remove User::InstanceMethods to silence a Rails 3.2 deprecation warning.
* Bump development dependency of cucumber-rails to 1.1.1.

New for 0.14.0:

* Support clearance session management from the Rack environment (Joe Ferris)

New for 0.13.2:

* Fixed the denies_access matcher (Chad Pytel, Joe Ferris)

New for 0.13.0:

* [#170] In Clearance's optional generated features, use pure Capybara instead of depending on Cucumber's removed web_steps, paths, and selectors. (Dan Croak)
* [#167] Extract SHA-1-specific code out of `User` into `PasswordStrategies` module. (Vladimir Andrijevik)
* [#164] Extract sign in form so that other methods can be added easily. (Subhash Chandra)
* [#165] Test against Rails 3.1. (Dan Croak) Required upgrades to Diesel and Appraisal. (Dan Croak, Mike Burns, Chad Pytel)
* [#160] Improved README documentation for overrides. (Dan Croak)

New for 0.12.0:

* [#129] Denying access redirects to root_url when signed in, sign_in_url when signed out. (Dan Croak)
* Using flash :notice key everywhere now instead of :success and :failure. More in line with Rails conventions. (Dan Croak)
* [#149] redirect_back_or on sign up. (Dan Croak)
* [#147] Resetting password no longer redirects to sign in page. It displays a message telling them to look for an email. (Dan Croak)
* Removed redundant flash messages. ("Signed in.", "Signed out.", and "You are now signed up.") (Dan Croak)

New for 0.11.2:

* Rails 3.1.rc compatible. (Prem Sichanugrist and Dan Croak)
* Cucumber features no longer require password. (Dan Croak)
* No more Clearance shoulda_macros. Instead providing RSpec- and Test::Unit-compliant test matchers (sign_in, sign_in_as, should deny_access, etc). (Dan Croak)

New for 0.11.1:

* [#146] Redirect to home page after sign up. (Dan Croak)
* [#145] Remove dependency on dynamic_form. Replaced with flashes due to limited number of failure cases. (Dan Croak)
* Moving ClearanceMailer to app/mailers. Moving spec to spec/mailers. (Dan Croak)
* [#148] Removing :case_sensitive option from validates_uniqueness_of. It was unnecessary and causes a small performance problem on some apps. (Dan Croak)
* Only development dependency in gemspec should be bundler. All others are derived by bundling. (Dan Croak)

New for 0.11.0:

* [#141] Removing password confirmation. (Dan Croak)
* [#143] Use ActiveSupport::Concern and ActiveSupport::SecureRandom to clean up code. (Dan Croak)
* New controller#authenticate(params) method. Redefine username & password or other styles of authentication. (Dan Croak)
* before_filter :authenticate API replaced with more aptly-named before_filter :authorize. (Dan Croak)

New for 0.10.5:

* Closing CSRF hole for Rails >= 3.0.4 apps (Mack Earnhardt)

New for 0.10.4:

* Formtastic views generator removed. (Dan Croak)
* Emails forced to be downcased (particularly for iPhone user case). (Adam Conrad)
* Suite converted from test/unit to RSpec. (Joe Ferris)
* [#135] Password reset requires a password. (Joel Meador)
* [#138] Use HTML5 email fields. (Dan Croak)

New for 0.10.3.2:

* Fix gemspec to include all necessary files.

New for 0.10.3.1:

* Ensure everything within features inside any engine directory is included in the gemspec

New for 0.10.3:

* Include features/engines in gemspec file list so generator works as expected

New for 0.10.2:

* Replaced test/rails_root & general testing strategy with Diesel. (Joe Ferris)
* Conveniences in factories for password/confirmation.
* New generator command: rails generate clearance:install.
* Step definitions are now prefixed with visitor_ to use thoughtbot convention. (Dan Croak)
* When Clearance installed in an app that already has users, allow old users to sign in by resetting their password.

New for 0.10.1:

* replaced ActionController::Forbidden with a user-friendly flash message. (Dan Croak)
* improved language of Cucumber steps by allowing a little more flexibility. (Dan Croak)

New for 0.10.0:

* Lots of README cleanup
* Better email validation regex
* Removed email confirmation step, was mostly a hassle and can always be added back in
  at the application level (instead of engine level) if necessary
* Removed disable_with on forms since it does not allow IE users to submit forms. See more:

  https://github.com/rails/jquery-ujs/issues#issue/30
  http://bugs.jquery.com/ticket/7061

New for 0.9.1:

Forgot to update the changelog in a while, this is going to be brief:

* This release supports Rails 3, capybara, and shoulda 2.10+.

New for 0.8.9:

* Removed unnecessary db index. (Rich Thornett, doctorzaius)
* [#79] Allow customization of cookie duration. (Ron Newman, Dan Croak)
* [#77] rake generator:cleanup needed to be... cleaned up. (Ron Newman)

New for 0.8.8 (02/25/2010):

* Fixed sign_in and sign_out not setting current_user (Joe Ferris)

New for 0.8.7 (02/21/2010):

* [#43] Fixed global sign out bug. (Ryan McGreary)
* [#69] Allow Rails apps to before_filter :authenticate the entire app
in ApplicationController and still have password recovery work without
overriding any controllers. (Claudio Poli, Dan Croak)
* [#72] #[21] Rails3 fix for ActionController/ActionDispatch change.
(Joseph Holsten, Peter Haza, Dan Croak)

New for 0.8.6 (02/17/2010):

* Clearance features capitalization should match view text (Bobby Wilson)
* [#39] skip :authenticate before_filter in controllers so apps can easily
authenticate a whole site without subclassing (Matthew Ford)
* [#45] Added randomness to token and salt generation (Ryan McGeary)
* [#43] Reset the remember_token on sign out instead of sign in. Allows for the same
user to sign in from two locations at once. (Ryan McGeary)
* [#62] Append the version number to generated update migrations (Joe Ferris)
 * Allow overridden user models to skip email/password validations
conditionally. This makes username/facebook integration easier. (Joe Ferris)

New for 0.8.5 (01/20/2010):

* replaced routing hack with Clearance::Routes.draw(map) to give
more control to the application developer. (Dan Croak)
* removed attr_accessible from Clearance::User. (Dan Croak)
* fixed bug in password reset feature. (Ben Orenstein, Dan Croak)
* use Jeweler for gemming. (Dan Croak)
* remove dependency on root_path, use '/' instead. (Dan Croak)
* use Clearance.configure block to set mailer sender instead of
DO_NOT_REPLY constant. (Dan Croak)

New for 0.8.4 (12/08/2009):

* [#48] remove unnecessary require 'factory_girl' in generator (Dan Croak)
* reference gemcutter (not github) as the gem source in README (Dan Croak)
* add IRC, rdoc.info links to README (Dan Croak)
* move user confirmation email trigger into model (Chad Pytel)

New for 0.8.3 (09/21/2009):

* [#27] remove class_eval in Clearance::Authentication. (Anuj Dutta)
* Avoid possible collisions in the remember me token (Joe Ferris)

New for 0.8.2 (09/01/2009):

* current_user= accessor method. (Joe Ferris, Josh Clayton)
* set current_user in sign_in. (Jon Yurek)

New for 0.8.1 (08/31/2009):

* Removed unnecessary remember_token_expires_at column and the
remember? and forget_me! user instance methods. (Dan Croak)

New for 0.8.0 (08/31/2009):

* Always remember me. Replaced session-and-remember-me authentication with
always using a cookie with a long timeout. (Dan Croak)
* Documented Clearance::Authentication with YARD. (Dan Croak)
* Documented Clearance::User with YARD. (Dan Croak)

New for 0.7.0 (08/04/2009):

* Redirect signed in user who clicks confirmation link again. (Dan Croak)
* Redirect signed out user who clicks confirmation link again. (Dan Croak)
* Added signed_out? convenience method for controllers, helpers, views. (Dan
Croak)
* Added clearance_views generator. By default, creates formtastic views which
pass all tests and features. (Dan Croak)

New for 0.6.9 (07/04/2009):

* Added timestamps to create users migration. (Dan Croak)
* Ready for Ruby 1.9. (Jason Morrison, Nick Quaranto)

New for 0.6.8 (06/24/2009):

* Added defined? checks for various Rails constants such as ActionController
for easier unit testing of Clearance extensions... particularly ActiveRecord
extensions... particularly strong_password. (Dan Croak)

New for 0.6.7 (06/13/2009):

* [#30] Added sign_up, sign_in, sign_out named routes. (Dan Croak)
* [#22] Minimizing Reek smell: Duplication in redirect_back_or. (Dan Croak)
* Deprecated sign_user_in. Told developers to use sign_in instead. (Dan
Croak)
* [#16] flash_success_after_create, flash_notice_after_create, flash_failure_after_create, flash_sucess_after_update, flash_success_after_destroy, etc. (Dan Croak)
* [#17] bug. added #create to forbidden before_filters on confirmations controller. (Dan Croak)
* [#24] should_be_signed_in_as shouldn't look in the session. (Dan Croak)
* README improvements. (Dan Croak)
* Move routes loading to separate file. (Joshua Clayton)

New for 0.6.6 (05/18/2009):

* [#14] replaced class_eval in Clearance::User with modules. This was needed
in a thoughtbot client app so we could write our own validations. (Dan Croak)

New for 0.6.5 (05/17/2009):

* [#6] Make Clearance i18n aware. (Timur Vafin, Marcel Goerner, Eugene Bolshakov, Dan Croak)

New for 0.6.4 (05/12/2009):

* Moved issue tracking to Github from Lighthouse. (Dan Croak)
* [#7] asking higher-level questions of controllers in webrat steps, such as signed_in? instead of what's in the session. same for accessors. (Dan Croak)
* [#11] replacing sign_in_as & sign_out shoulda macros with a stubbing (requires no dependency) approach. this will avoid dealing with the internals of current_user, such as session & cookies. added sign_in macro which signs in an email confirmed user from clearance's factories. (Dan Croak)
* [#13] move private methods on sessions controller into Clearance::Authentication module (Dan Croak)
* [#9] audited flash keys. (Dan Croak)

New for 0.6.3 (04/23/2009):

* Scoping ClearanceMailer properly within controllers so it works in production environments. (Nick Quaranto)

New for 0.6.2 (04/22/2009):

* Insert Clearance::User into User model if it exists. (Nick Quaranto)
* World(NavigationHelpers) Cucumber 3.0 style. (Shay Arnett & Mark Cornick)

New for 0.6.1 (04/21/2009):

* Scope operators are necessary to keep Rails happy. Reverting the original
revert so they're back in the library now for constants referenced inside of
the gem. (Nick Quaranto)

New for 0.6.0 (04/21/2009):

* Converted Clearance to a Rails engine. (Dan Croak & Joe Ferris)
* Include Clearance::User in User model in app. (Dan Croak & Joe Ferris)
* Include Clearance::Authentication in ApplicationController. (Dan Croak & Joe Ferris)
* Namespace controllers under Clearance. (Dan Croak & Joe Ferris)
* Routes move to engine, use namespaced controllers but publicly the same. (Dan Croak & Joe Ferris)
* If you want to override a controller, subclass it like SessionsController <
Clearance::SessionsController. This gives you access to usual hooks such as
url_after_create. (Dan Croak & Joe Ferris)
* Controllers, mailer, model, routes all unit tested inside engine. Use
script/generate clearance_features to test integration of Clearance with your
Rails app. No longer including modules in your app's test files. (Dan Croak & Joe Ferris)
* Moved views to engine. (Joe Ferris)
* Converted generated test/factories/clearance.rb to use inheritence for
email_confirmed_user. (Dan Croak)
* Corrected some spelling errors with methods (Nick Quaranto)
* Converted "I should see error messages" to use a regex in the features (Nick
Quaranto)
* Loading clearance routes after rails routes via some monkeypatching (Nick
Quaranto)
* Made the clearance controllers unloadable to stop constant loading errors in
development mode (Nick Quaranto)

New for 0.5.6 (4/11/2009):

* [#57] Step definition changed for "User should see error messages" so
features won't fail for certain validations. (Nick Quaranto)

New for 0.5.5 (3/23/2009):

* Removing duplicate test to get rid of warning. (Nick Quaranto)

New for 0.5.4 (3/21/2009):

* When users fail logging in, redirect them instead of rendering. (Matt
Jankowski)

New for 0.5.3 (3/5/2009):

* Clearance now works with (and requires) Shoulda 2.10.0. (Mark Cornick, Joe
Ferris, Dan Croak)
* Prefer flat over nested contexts in sessions_controller_test. (Joe Ferris,
Dan Croak)

New for 0.5.2 (3/2/2009):

* Fixed last remaining errors in Rails 2.3 tests. Now fully compatible. (Joe
Ferris, Dan Croak)

New for 0.5.1 (2/27/2009):

* [#46] A user with unconfirmed email who resets password now confirms email.
(Marcel Görner)
* Refactored user_from_cookie, user_from_session, User#authenticate to use
more direct return code instead of ugly, harder to read ternary. (Dan Croak)
* Switch order of cookies and sessions to take advantage of Rails 2.3's "Rack-based lazy-loaded sessions":http://is.gd/i23E. (Dan Croak)
* Altered generator to interact with application_controller.rb instead of
application.rb in Rails 2.3 apps. (Dan Croak)
* [#42] Bug fix. Rack-based session change altered how to test remember me
cookie. (Mihai Anca)

New for 0.5.0 (2/27/2009):

* Fixed problem with Cucumber features. (Dan Croak)
* Fixed mising HTTP fluency use case. (Dan Croak)
* Refactored User#update_password to take just parameters it needs. (Dan
Croak)
* Refactored User unit tests to be more readable. (Dan Croak)

New for 0.4.9 (2/20/2009):

* Protect passwords & confirmations actions with forbidden filters. (Dan Croak)
* Return 403 Forbidden status code in those cases. (Tim Pope)
* Test 403 Forbidden status code in Cucumber feature. (Dan Croak, Joe Ferris)
* Raise custom ActionController::Forbidden error internally. (Joe Ferris, Mike Burns, Jason Morrison)
* Test ActionController::Forbidden error is raised in functional test. (Joe Ferris, Mike Burns, Dan Croak)
* [#45] Fixed bug that allowed anyone to edit another user's password (Marcel Görner)
* Required Factory Girl >= 1.2.0. (Dan Croak)

New for 0.4.8 (2/16/2009):

* Added support paths for Cucumber. (Ben Mabey)
* Added documentation for the flash. (Ben Mabey)
* Generators require "test_helper" instead of File.join. for rr compatibility. (Joe Ferris)
* Removed interpolated email address from flash message to make i18n easier. (Bence Nagy)
* Standardized flash messages that refer to email delivery. (Dan Croak)

New for 0.4.7 (2/12/2009):

* Removed Clearance::Test::TestHelper so there is one less setup step. (Dan Croak)
* All test helpers now in shoulda_macros. (Dan Croak)

New for 0.4.6 (2/11/2009):

* Made the modules behave like mixins again. (hat-tip Eloy Duran)
* Created Actions and PrivateMethods modules on controllers for future RDoc reasons. (Dan Croak, Joe Ferris)

New for 0.4.5 (2/9/2009):

* [#43] Removed email downcasing because local-part is case sensitive per RFC5321. (Dan Croak)
* [#42] Removed dependency on Mocha. (Dan Croak)
* Required Shoulda >= 2.9.1. (Dan Croak)
* Added password reset feature to clearance_features generator. (Eugene Bolshakov, Dan Croak)
* Removed unnecessary session[:salt]. (Dan Croak)
* [#41] Only store location for session[:return_to] for GET requests. (Dan Croak)
* Audited "sign up" naming convention. "Register" had slipped in a few places. (Dan Croak)
* Switched to SHA1 encryption. Cypher doesn't matter much for email confirmation, password reset. Better to have shorter hashes in the emails for clients who line break on 72 chars. (Dan Croak)

New for 0.4.4 (2/2/2009):

* Added a generator for Cucumber features. (Joe Ferris, Dan Croak)
* Standarized naming for "Sign up," "Sign in," and "Sign out". (Dan Croak) 
