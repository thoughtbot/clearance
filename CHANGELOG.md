0.8.9 (unreleased)
------------------

* Removed unnecessary db index. (Rich Thorne, doctorzaius)

0.8.8 (02/25/2010)
------------------

* Fixed sign_in and sign_out not setting current_user (Joe Ferris)

0.8.7 (02/21/2010)
------------------

* [#43] Fixed global sign out bug. (Ryan McGreary)
* [#69] Allow Rails apps to before_filter :authenticate the entire app
in ApplicationController and still have password recovery work without
overriding any controllers. (Claudio Poli, Dan Croak)
* [#72] #[21] Rails3 fix for ActionController/ActionDispatch change.
(Joseph Holsten, Peter Haza, Dan Croak)

0.8.6 (02/17/2010)
------------------

* Clearance features capitalization should match view text (Bobby Wilson)
* [#39] skip :authenticate before_filter in controllers so apps can easily
authenticate a whole site without subclassing (Matthew Ford)
* [#45] Added randomness to token and salt generation (Ryan McGeary)
* [#43] Reset the remember_token on sign out instead of sign in. Allows for the same
user to sign in from two locations at once. (Ryan McGeary)
* [#62] Append the version number to generated update migrations (Joe Ferris)
 * Allow overridden user models to skip email/password validations
conditionally. This makes username/facebook integration easier. (Joe Ferris)

0.8.5 (01/20/2010)
------------------

* replaced routing hack with Clearance::Routes.draw(map) to give
more control to the application developer. (Dan Croak)
* removed attr_accessible from Clearance::User. (Dan Croak)
* fixed bug in password reset feature. (Ben Orenstein, Dan Croak)
* use Jeweler for gemming. (Dan Croak)
* remove dependency on root_path, use '/' instead. (Dan Croak)
* use Clearance.configure block to set mailer sender instead of
DO_NOT_REPLY constant. (Dan Croak)

0.8.4 (12/08/2009)
------------------

* [#48] remove unnecessary require 'factory_girl' in generator (Dan Croak)
* reference gemcutter (not github) as the gem source in README (Dan Croak)
* add IRC, rdoc.info links to README (Dan Croak)
* move user confirmation email trigger into model (Chad Pytel)

0.8.3 (09/21/2009)
------------------

* [#27] remove class_eval in Clearance::Authentication. (Anuj Dutta)
* Avoid possible collisions in the remember me token (Joe Ferris)

0.8.2 (09/01/2009)
------------------

* current_user= accessor method. (Joe Ferris, Josh Clayton)
* set current_user in sign_in. (Jon Yurek)

0.8.1 (08/31/2009)
------------------

* Removed unnecessary remember_token_expires_at column and the
remember? and forget_me! user instance methods. (Dan Croak)

0.8.0 (08/31/2009)
------------------

* Always remember me. Replaced session-and-remember-me authentication with
always using a cookie with a long timeout. (Dan Croak)
* Documented Clearance::Authentication with YARD. (Dan Croak)
* Documented Clearance::User with YARD. (Dan Croak)

0.7.0 (08/04/2009)
------------------

* Redirect signed in user who clicks confirmation link again. (Dan Croak)
* Redirect signed out user who clicks confirmation link again. (Dan Croak)
* Added signed_out? convenience method for controllers, helpers, views. (Dan
Croak)
* Added clearance_views generator. By default, creates formtastic views which
pass all tests and features. (Dan Croak)

0.6.9 (07/04/2009)
------------------

* Added timestamps to create users migration. (Dan Croak)
* Ready for Ruby 1.9. (Jason Morrison, Nick Quaranto)

0.6.8 (06/24/2009)
------------------

* Added defined? checks for various Rails constants such as ActionController
for easier unit testing of Clearance extensions... particularly ActiveRecord
extensions... particularly strong_password. (Dan Croak)

0.6.7 (06/13/2009)
------------------

* [#30] Added sign_up, sign_in, sign_out named routes. (Dan Croak)
* [#22] Minimizing Reek smell: Duplication in redirect_back_or. (Dan Croak)
* Deprecated sign_user_in. Told developers to use sign_in instead. (Dan
Croak)
* [#16] flash_success_after_create, flash_notice_after_create, flash_failure_after_create, flash_sucess_after_update, flash_success_after_destroy, etc. (Dan Croak)
* [#17] bug. added #create to forbidden before_filters on confirmations controller. (Dan Croak)
* [#24] should_be_signed_in_as shouldn't look in the session. (Dan Croak)
* README improvements. (Dan Croak)
* Move routes loading to separate file. (Joshua Clayton)

0.6.6 (05/18/2009)
------------------

* [#14] replaced class_eval in Clearance::User with modules. This was needed
in a thoughtbot client app so we could write our own validations. (Dan Croak)

0.6.5 (05/17/2009)
------------------

* [#6] Make Clearance i18n aware. (Timur Vafin, Marcel Goerner, Eugene Bolshakov, Dan Croak)

0.6.4 (05/12/2009)
------------------

* Moved issue tracking to Github from Lighthouse. (Dan Croak)
* [#7] asking higher-level questions of controllers in webrat steps, such as signed_in? instead of what's in the session. same for accessors. (Dan Croak)
* [#11] replacing sign_in_as & sign_out shoulda macros with a stubbing (requires no dependency) approach. this will avoid dealing with the internals of current_user, such as session & cookies. added sign_in macro which signs in an email confirmed user from clearance's factories. (Dan Croak)
* [#13] move private methods on sessions controller into Clearance::Authentication module (Dan Croak)
* [#9] audited flash keys. (Dan Croak)

0.6.3 (04/23/2009)
------------------

* Scoping ClearanceMailer properly within controllers so it works in production environments. (Nick Quaranto)

0.6.2 (04/22/2009)
------------------

* Insert Clearance::User into User model if it exists. (Nick Quaranto)
* World(NavigationHelpers) Cucumber 3.0 style. (Shay Arnett & Mark Cornick)

0.6.1 (04/21/2009)
------------------

* Scope operators are necessary to keep Rails happy. Reverting the original
revert so they're back in the library now for constants referenced inside of
the gem. (Nick Quaranto)

0.6.0 (04/21/2009)
------------------

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

0.5.6 (4/11/2009)
-----------------

* [#57] Step definition changed for "User should see error messages" so
features won't fail for certain validations. (Nick Quaranto)

0.5.5 (3/23/2009)
-----------------

* Removing duplicate test to get rid of warning. (Nick Quaranto)

0.5.4 (3/21/2009)
-----------------

* When users fail logging in, redirect them instead of rendering. (Matt
Jankowski)

0.5.3 (3/5/2009)
----------------

* Clearance now works with (and requires) Shoulda 2.10.0. (Mark Cornick, Joe
Ferris, Dan Croak)
* Prefer flat over nested contexts in sessions_controller_test. (Joe Ferris,
Dan Croak)

0.5.2 (3/2/2009)
----------------

* Fixed last remaining errors in Rails 2.3 tests. Now fully compatible. (Joe
Ferris, Dan Croak)

0.5.1 (2/27/2009)
-----------------

* [#46] A user with unconfirmed email who resets password now confirms email.
(Marcel Görner)
* Refactored user_from_cookie, user_from_session, User#authenticate to use
more direct return code instead of ugly, harder to read ternary. (Dan Croak)
* Switch order of cookies and sessions to take advantage of Rails 2.3's "Rack-based lazy-loaded sessions":http://is.gd/i23E. (Dan Croak)
* Altered generator to interact with application_controller.rb instead of
application.rb in Rails 2.3 apps. (Dan Croak)
* [#42] Bug fix. Rack-based session change altered how to test remember me
cookie. (Mihai Anca)

0.5.0 (2/27/2009)
-----------------

* Fixed problem with Cucumber features. (Dan Croak)
* Fixed mising HTTP fluency use case. (Dan Croak)
* Refactored User#update_password to take just parameters it needs. (Dan
Croak)
* Refactored User unit tests to be more readable. (Dan Croak)

0.4.9 (2/20/2009)
-----------------

* Protect passwords & confirmations actions with forbidden filters. (Dan Croak)
* Return 403 Forbidden status code in those cases. (Tim Pope)
* Test 403 Forbidden status code in Cucumber feature. (Dan Croak, Joe Ferris)
* Raise custom ActionController::Forbidden error internally. (Joe Ferris, Mike Burns, Jason Morrison)
* Test ActionController::Forbidden error is raised in functional test. (Joe Ferris, Mike Burns, Dan Croak)
* [#45] Fixed bug that allowed anyone to edit another user's password (Marcel Görner)
* Required Factory Girl >= 1.2.0. (Dan Croak)

0.4.8 (2/16/2009)
-----------------

* Added support paths for Cucumber. (Ben Mabey)
* Added documentation for the flash. (Ben Mabey)
* Generators require "test_helper" instead of File.join. for rr compatibility. (Joe Ferris)
* Removed interpolated email address from flash message to make i18n easier. (Bence Nagy)
* Standardized flash messages that refer to email delivery. (Dan Croak)

0.4.7 (2/12/2009)
-----------------

* Removed Clearance::Test::TestHelper so there is one less setup step. (Dan Croak)
* All test helpers now in shoulda_macros. (Dan Croak)

0.4.6 (2/11/2009)
-----------------

* Made the modules behave like mixins again. (hat-tip Eloy Duran)
* Created Actions and PrivateMethods modules on controllers for future RDoc reasons. (Dan Croak, Joe Ferris)

0.4.5 (2/9/2009)
----------------

* [#43] Removed email downcasing because local-part is case sensitive per RFC5321. (Dan Croak)
* [#42] Removed dependency on Mocha. (Dan Croak)
* Required Shoulda >= 2.9.1. (Dan Croak)
* Added password reset feature to clearance_features generator. (Eugene Bolshakov, Dan Croak)
* Removed unnecessary session[:salt]. (Dan Croak)
* [#41] Only store location for session[:return_to] for GET requests. (Dan Croak)
* Audited "sign up" naming convention. "Register" had slipped in a few places. (Dan Croak)
* Switched to SHA1 encryption. Cypher doesn't matter much for email confirmation, password reset. Better to have shorter hashes in the emails for clients who line break on 72 chars. (Dan Croak)

0.4.4 (2/2/2009)
----------------

* Added a generator for Cucumber features. (Joe Ferris, Dan Croak)
* Standarized naming for "Sign up," "Sign in," and "Sign out". (Dan Croak) 
