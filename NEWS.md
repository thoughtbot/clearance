Thank you to all the [contributors](https://github.com/thoughtbot/clearance/graphs/contributors)!

New for 1.0.1 (August 9, 2013):

* Fix an issue when trying to sign in with `nil`

New for 1.0.0 (August 1, 2013):

* Support Rails 4.
* Change default password strategy to BCrypt.
* Speed up test suites using `::BCrypt::Engine::MIN_COST`.
* Speed up integration suites with `Clearance::BackDoor`.
* Replace email regular expression with `EmailValidator` gem.
* Provide `BCryptMigrationFromSHA1` password strategy to help people migrate from
  SHA1 (the old default password strategy) to BCrypt (the new default).
* Support Ruby 2.
* Require > Ruby 1.9.
* More extension points in more controllers.
* The `email`, `encrypted_password`, and `remember_token` fields of the users
  table are `NOT NULL` in the default migration.
* Add `SignedIn` and `SignedOut` routing constraints.
* Add a fake password strategy, which is useful when writing tests.
* Improve security when changing password.
* Replace Cucumber feature generator with RSpec + Capybara.
* Remove Diesel dependency.
* Remove deprecated methods on User: `remember_me!`, `generate_random_code`,
  `password_required?`.
* `PasswordsController` `params[:user]` has changed to `params[:password_reset]`
  to avoid locale conflicts.
* Remove `unloadable` from controllers (Rails 4 bug fix in development
  environment).
* Add `redirect_url` configuration option.
* Add `secure_cookie` configuration option.
* Unauthorized API requests return HTTP status 401 rather than a redirect
  to the sign in page.
* Remove support for supplying `return_to` value via request parameter.
* Reduce extra user lookups when adding cookie to headers.

New for 0.16.2 (May 11, 2012):

* Change default email sender to `deploy@example.com`.

New for 0.16.1 (April 16, 2012):

* Behave correctly when Rails whitelist attributes mass assignment
  protection is turned on.
* Fix for Rails 3.2.x modifying the HTTP cookie headers in rack requests.

New for 0.16.0 (March 16, 2012):

* Blowfish password encryption strategy.

New for 0.15.0 (February 3, 2012):

* The `User` model can be swapped out using the `Clearance.configure` method.
* Remove `User::InstanceMethods` to silence a Rails 3.2 deprecation warning.
* Bump development dependency of cucumber-rails to 1.1.1.

New for 0.14.0 (January 13, 2012):

* Support clearance session management from the Rack environment.

New for 0.13.2 (January 13, 2012):

* Fixed the `deny_access` matcher.

New for 0.13.0 (October 11, 2011):

* In Clearance's optional generated features, use pure Capybara instead of
  depending on Cucumber's removed `web_steps`, paths, and selectors.
* Extract SHA-1-specific code out of `User` into `PasswordStrategies` module.
* Extract sign in form so that other methods can be added easily.
* Test against Rails 3.1. Required upgrades to Diesel and Appraisal.
* Improved README documentation for overrides.

New for 0.12.0 (June 30, 2011):

* Denying access redirects to `root_url` when signed in, `sign_in_url` when signed
  out.
* Using flash `:notice` key everywhere now instead of `:success` and `:failure`. More
  in line with Rails conventions.
* `redirect_back_or` on sign up.
* Resetting password no longer redirects to sign in page. It displays a message
  telling them to look for an email.
* Removed redundant flash messages. ("Signed in.", "Signed out.", and "You are
  now signed up.")

New for 0.11.2 (June 29, 2011):

* Rails 3.1.rc compatible.
* Cucumber features no longer require password.
* No more Clearance `shoulda_macros`. Instead providing RSpec- and
  Test::Unit-compliant test matchers (`should deny_access`, etc).

New for 0.11.1 (April 30, 2011):

* Redirect to home page after sign up.
* Remove dependency on `dynamic_form`. Replaced with flashes due to limited number
  of failure cases.
* Moving `ClearanceMailer` to `app/mailers`. Moving spec to `spec/mailers`.
* Removing `:case_sensitive` option from `validates_uniqueness_of`. It was
  unnecessary and causes a small performance problem on some apps.
* Only development dependency in `gemspec` should be `bundler`. All others are
  derived by bundling.

New for 0.11.0 (April 24, 2011):

* Removing password confirmation.
* Use `ActiveSupport::Concern` and `ActiveSupport::SecureRandom` to clean up code.
* New `controller#authenticate(params)` method. Redefine username & password or
  other styles of authentication.
* `before_filter :authenticate` API replaced with more aptly-named `before_filter
  :authorize`.

New for 0.10.5 (April 19, 2011):

* Closing CSRF hole for Rails >= 3.0.4 apps.

New for 0.10.4 (April 16, 2011):

* Formtastic views generator removed.
* Emails forced to be downcased (particularly for iPhone user case).
* Suite converted from test/unit to RSpec.
* Password reset requires a password.
* Use HTML5 email fields.

New for 0.10.3.2 (March 6, 2011):

* Fix gemspec to include all necessary files.

New for 0.10.3.1 (February 20, 2011):

* Ensure everything within features inside any engine directory is included in
  the `gemspec`.

New for 0.10.3 (February 19, 2011):

* Include features/engines in `gemspec` file list so generator works as
  expected.

New for 0.10.2 (February 18, 2011):

* Replaced `test/rails_root` & general testing strategy with Diesel.
* Conveniences in factories for password/confirmation.
* New generator command: `rails generate clearance:install`.
* Step definitions are now prefixed with `visitor_` to use thoughtbot
  convention.
* When Clearance installed in an app that already has users, allow old users to
  sign in by resetting their password.

New for 0.10.1 (February 9, 2011):

* Replaced `ActionController::Forbidden` with a user-friendly flash message.
* Improved language of Cucumber steps by allowing a little more flexibility.

New for 0.10.0 (June 29, 2010):

* Better email validation regular expression.
* Removed email confirmation step, was mostly a hassle and can always be added
  back in at the application level (instead of engine level) if necessary.
* Removed `disable_with` on forms since it does not allow IE users to submit
  forms. [Read more](https://github.com/rails/jquery-ujs/issues#issue/30).

New for 0.9.1 (June 29, 2010):

* This release supports Rails 3, capybara, and shoulda 2.10+.

New for 0.9.0 (June 11, 2010):

* Removed unnecessary db index.
* Allow customization of cookie duration.
* `rake generator:cleanup` needed to be... cleaned up.

New for 0.8.8 (February 25, 2010):

* Fixed `sign_in` and `sign_out` not setting `current_user`.

New for 0.8.7 (February 21, 2010):

* Fixed global sign out bug.
* Allow Rails apps to `before_filter :authenticate` the entire app
  in `ApplicationController` and still have password recovery work without
  overriding any controllers.
* Rails 3 fix for `ActionController`/`ActionDispatch` change.

New for 0.8.6 (February 17, 2010):

* Clearance features capitalization should match view text.
* Skip `:authenticate before_filter` in controllers so apps can easily
  authenticate a whole site without subclassing.
* Added randomness to token and salt generation,
* Reset the `remember_token` on sign out instead of sign in. Allows for the same
  user to sign in from two locations at once.
* Append the version number to generated update migrations.
* Allow overridden user models to skip email/password validations
  conditionally. This makes username/facebook integration easier.

New for 0.8.5 (January 20, 2010):

* Replaced routing hack with `Clearance::Routes.draw(map)` to give more control
  to the application developer.
* Removed `attr_accessible` from `Clearance::User`.
* Fixed bug in password reset feature.
* Use Jeweler for gemming.
* Remove dependency on `root_path`, use `'/'` instead.
* Use `Clearance.configure` block to set mailer sender instead of `DO_NOT_REPLY`
  constant.

New for 0.8.4 (December 08, 2009):

* Remove unnecessary `require 'factory_girl'` in generator.
* Reference gemcutter (not github) as the gem source in README.
* Add IRC, rdoc.info links to README.
* Move user confirmation email trigger into model.

New for 0.8.3 (September 21, 2009):

* Remove `class_eval` in `Clearance::Authentication`.
* Avoid possible collisions in the remember me token.

New for 0.8.2 (September 01, 2009):

* `current_user= accessor` method.
* Set `current_user` in `sign_in`.

New for 0.8.1 (August 31, 2009):

* Removed unnecessary `remember_token_expires_at` column and the
  `remember?` and `forget_me!` user instance methods.

New for 0.8.0 (August 31, 2009):

* Always remember me. Replaced session-and-remember-me authentication with
  always using a cookie with a long timeout.
* Documented `Clearance::Authentication` with YARD.
* Documented `Clearance::User` with YARD.

New for 0.7.0 (August 4, 2009):

* Redirect signed in user who clicks confirmation link again.
* Redirect signed out user who clicks confirmation link again.
* Added `signed_out?` convenience method for controllers, helpers, views.
* Added `clearance_views` generator. By default, creates formtastic views which
  pass all tests and features.

New for 0.6.9 (July 4, 2009):

* Added timestamps to create users migration.
* Ready for Ruby 1.9.

New for 0.6.8 (June 24, 2009):

* Added `defined?` checks for various Rails constants such as `ActionController`
  for easier unit testing of Clearance extensions... particularly `ActiveRecord`
  extensions... `particularly strong_password`.

New for 0.6.7 (June 13, 2009):

* Added `sign_up`, `sign_in`, `sign_out` named routes.
* Minimizing Reek smell: Duplication in `redirect_back_or`.
* Deprecated `sign_user_in`. Told developers to use `sign_in` instead.
* `flash_success_after_create`, `flash_notice_after_create`,
  `flash_failure_after_create`, `flash_sucess_after_update`,
  `flash_success_after_destroy`, etc.
* Added `#create` to forbidden `before_filters` on confirmations controller.
* `should_be_signed_in_as` shouldn't look in the session.
* README improvements.
* Move routes loading to separate file.

New for 0.6.6 (May 18, 2009):

* replaced `class_eval` in `Clearance::User` with modules. This was needed
  so we could write our own validations.

New for 0.6.5 (May 17, 2009):

* Make Clearance i18n aware.

New for 0.6.4 (May 12, 2009):

* Moved issue tracking to Github from Lighthouse.
* Asking higher-level questions of controllers in webrat steps, such as
  `signed_in`? instead of what's in the session. same for accessors.
* Replacing `sign_in_as` & `sign_out` shoulda macros with a stubbing (requires no
  dependency) approach. this will avoid dealing with the internals of
  `current_user`, such as session & cookies. Added `sign_in` macro which signs in an
  email confirmed user from clearance's factories.
* Move private methods on sessions controller into `Clearance::Authentication`
  module.
* Audited flash keys.

New for 0.6.3 (April 23, 2009):

* Scoping `ClearanceMailer` properly within controllers so it works in
  production environments.

New for 0.6.2 (April 22, 2009):

* Insert `Clearance::User` into User model if it exists.
* `World(NavigationHelpers)` Cucumber 3.0 style.

New for 0.6.1 (April 21, 2009):

* Scope operators are necessary to keep Rails happy. Reverting the original
  revert so they're back in the library now for constants referenced inside of
  the gem.

New for 0.6.0 (April 21, 2009):

* Converted Clearance to a Rails engine.
* Include `Clearance::User` in User model in app.
* Include `Clearance::Authentication` in `ApplicationController`.
* Namespace controllers under `Clearance` module.
* Routes move to engine, use namespaced controllers but publicly the same.
* If you want to override a controller, subclass it like `SessionsController <
  Clearance::SessionsController`. This gives you access to usual hooks such as
  `url_after_create`.
* Controllers, mailer, model, routes all unit tested inside engine. Use
  `script/generate clearance_features` to test integration of Clearance with your
  Rails app. No longer including modules in your app's test files.
* Moved views to engine.
* Converted generated `test/factories/clearance.rb` to use inheritence for
  `email_confirmed_user`.
* Corrected some spelling errors with methods.
* Converted "I should see error messages" to use a regex in the features.
* Loading clearance routes after rails routes via some monkeypatching.
* Made the clearance controllers `unloadable` to stop constant loading errors in
  development mode.

New for 0.5.6 (April 11, 2009):

* Step definition changed for "User should see error messages" so features won't
  fail for certain validations.

New for 0.5.5 (March 23, 2009):

* Removing duplicate test to get rid of warning.

New for 0.5.4 (March 21, 2009):

* When users fail logging in, redirect them instead of rendering.

New for 0.5.3 (March 5, 2009):

* Clearance now works with (and requires) Shoulda 2.10.0.
* Prefer flat over nested contexts in `sessions_controller_test`.

New for 0.5.2 (March 2, 2009):

* Fixed last remaining errors in Rails 2.3 tests. Now fully compatible.

New for 0.5.1 (February 27, 2009):

* A user with unconfirmed email who resets password now confirms email.
* Refactored `user_from_cookie`, `user_from_session`, `User#authenticate` to use
  more direct return code instead of ugly, harder to read ternary.
* Switch order of cookies and sessions to take advantage of Rails 2.3's
  "Rack-based lazy-loaded sessions",
* Altered generator to interact with `application_controller.rb` instead of
  `application.rb` in Rails 2.3 apps.
* Bug fix. Rack-based session change altered how to test remember me cookie.

New for 0.5.0 (February 27, 2009):

* Fixed problem with Cucumber features.
* Fixed mising HTTP fluency use case.
* Refactored `User#update_password` to take just parameters it needs.
* Refactored `User` unit tests to be more readable.

New for 0.4.9 (February 20, 2009):

* Protect passwords & confirmations actions with forbidden filters.
* Return 403 Forbidden status code in those cases.
* Test 403 Forbidden status code in Cucumber feature.
* Raise custom `ActionController::Forbidden` error internally.
* Test `ActionController::Forbidden` error is raised in functional test.
* Fixed bug that allowed anyone to edit another user's password.
* Required Factory Girl >= 1.2.0.

New for 0.4.8 (February 16, 2009):

* Added support paths for Cucumber.
* Added documentation for the flash.
* Generators `require 'test_helper'` instead of `File.join` for RR compatibility.
* Removed interpolated email address from flash message to make i18n easier.
* Standardized flash messages that refer to email delivery.

New for 0.4.7 (February 12, 2009):

* Removed `Clearance::Test::TestHelper` so there is one less setup step.
* All test helpers now in `shoulda_macros`.

New for 0.4.6 (February 11, 2009):

* Made the modules behave like mixins again.
* Created `Actions` and `PrivateMethods` modules on controllers for future RDoc
  reasons.

New for 0.4.5 (February 9, 2009):

* Removed email downcasing because local-part is case sensitive per
  RFC5321.
* Removed dependency on Mocha.
* Required Shoulda >= 2.9.1.
* Added password reset feature to `clearance_features` generator.
* Removed unnecessary `session[:salt]`.
* Only store location for `session[:return_to]` for GET requests.
* Audited "sign up" naming convention. "Register" had slipped in a few places.
* Switched to `SHA1` encryption. Cypher doesn't matter much for email
  confirmation, password reset. Better to have shorter hashes in the emails for
  clients who line break on 72 chars.

New for 0.4.4 (February 2, 2009):

* Added a generator for Cucumber features.
* Standardized naming for "Sign up," "Sign in," and "Sign out".
