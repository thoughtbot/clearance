# News

The noteworthy changes for each Clearance version are included here. For a
complete changelog, see the git history for each version via the version links.

## [1.11.0] - August 21, 2015

### Added
- Add `sign_in` and `sign_in_as` helper methods to view specs. These helpers
  avoid errors from verified partial doubles that come from. See
  [462c009].

### Fixed
- `clearance:routes` generator now properly disables internal routes in your
  Clearance initializer.
- Clearance now accesses the cookie jar via ActionDispatch::Request rather than
  `Rack::Request`. This is more consistent with what Rails does internally.

### Deprecated
- `Clearance::Testing::Helpers` has been deprecated in favor of
  `Clearance::Testing::ControllerHelpers`. Most users are accessing these
  helpers by requiring `clearance/rspec` or `clearance/test_unit` and should be
  unaffected.

[462c009]: https://github.com/thoughtbot/clearance/commit/462c00965c14b2492500fbb4fecd7b84b9790bb9
[1.11.0]: https://github.com/thoughtbot/clearance/compare/v1.10.1...v1.11.0

## [1.10.1] - May 15, 2015

### Deprecated
- All clearance-provided password strategies other than BCrypt have been
  deprecated. You can continue to use those strategies without a deprecation
  warning by adding `clearance-deprecated_password_strategies` to your Gemfile.

[1.10.1]: https://github.com/thoughtbot/clearance/compare/v1.9.0...v1.10.1

## [1.9.0] - April 3, 2015

### Added
- The change password mailer now produces a multipart message which includes a
  text part along with the previously existing HTML part. To override the text
  part, add `change_password.text.erb` alongside your `change_password.html.erb`
  file.

### Fixed
- Custom `user_model` configured in a Rails initializer will now be reloaded in
  development mode.
- Change password template now contains "Change my password" link text to
  address an issue linking the URL in some mail clients.

[1.9.0]: https://github.com/thoughtbot/clearance/compare/v1.8.1...v1.9.0

## [1.8.1] - March 3, 2015

### Security
- Enable cross-site request forgery protection on `sessions#create`. See
  [7f5d56e](https://github.com/thoughtbot/clearance/commit/7f5d56ed3a51aca14fa60247a90ca0cd11db0e0d).

### Fixed
- All methods included by `Clearance::Controller` are now excluded from
  `action_methods`.

[1.8.1]: https://github.com/thoughtbot/clearance/compare/v1.8.0...v1.8.1

## [1.8.0] - January 23, 2015

### Added
- The remember token cookie name is now customizable via
  `Clearance.configuration.cookie_name`.

### Fixed
- Fixed a redirect loop on the sign in page for applications that are still
  using the deprecated `authorize` filter.
- Signed in users that attempt to visit the sign in path are now redirected. The
  redirect URL defaults to the same URL used for the redirect after sign in, but
  can be customized by overriding `passwords_controller#url_for_signed_in_users`

### Deprecated
- `users_controller#avoid_sign_in` is now deprecated in favor of
  `redirect_signed_in_users` which is more accurately named.

[1.8.0]: https://github.com/thoughtbot/clearance/compare/v1.7.0...v1.8.0

## [1.7.0] - January, 8, 2015

### Fixed
- Fix the negation of the `deny_access` matcher in Rails 4.0.x on Ruby 2.2

### Deprecated
- The `authorize` filter has been deprecated in favor of `require_login`. Update
  all reference to the filter including any calls to `skip_before_filter` or
  `skip_before_action`.
- The `Clearance.root` method has been deprecated. It was used internally and
  unlikely to impact external users.

[1.7.0]: https://github.com/thoughtbot/clearance/compare/v1.6.1...v1.7.0

## [1.6.1] - January 6, 2015

### Fixed
- Secure cookies are no longer overwritten when the user visits a non-HTTPS URL.

[1.6.1]: https://github.com/thoughtbot/clearance/compare/v1.6.0...v1.6.1

## [1.6.0] - December 20, 2014

### Added
- When using Rails 4.2, password reset emails are sent with the
  ActiveJob-compatible `#deliver_later` method.

[1.6.0]: https://github.com/thoughtbot/clearance/compare/v1.5.1...v1.6.0

## [1.5.1] - December 19, 2014

### Fixed
- Blowfish password strategy fixed
- Specs generated with `rails generate clearance:specs` now work properly in
  RSpec 3 projects.

[1.5.1]: https://github.com/thoughtbot/clearance/compare/v1.5.0...v1.5.1

## [1.5.0] - October 17, 2014

### Added
- Disable clearance routes by setting `config.routes = false`.
- Running `rails generate clearance:routes` will dump the default set of
  routes to your application's routes file for modification.

[1.5.0]: https://github.com/thoughtbot/clearance/compare/v1.4.3...v1.5.0

## [1.4.3] - October 3, 2014

### Fixed
- Routing constraints act appropriately when session data is missing.

[1.4.3]: https://github.com/thoughtbot/clearance/compare/v1.4.2...v1.4.3

## [1.4.2] - September 13, 2014

### Fixed
- Eliminate deprecation message when using DenyAccess matcher with RSpec 3.

[1.4.2]: https://github.com/thoughtbot/clearance/compare/v1.4.1...v1.4.2

## [1.4.1] - September 5, 2014

### Fixed
- Prevent BCrypt strategy from raising an exception when `encypted_password`
  is nil.

[1.4.1]: https://github.com/thoughtbot/clearance/compare/v1.4.0...v1.4.1

## [1.4.0] - July 18, 2014

### Added
- `user_params` method was added to `Clearance::UsersController` which provides
  a convenient place to override the parameters used when creating users.
- Controllers now inherit from `Clearance::BaseController` to allow for easily
  adding behavior to all of them.

### Changed
- The sign out link in the default application layout has been replaced with a
  semantically correct sign out button. This also removes an unnecessary
  JavaScript dependency.

### Fixed
- Clearance now uses `original_fullpath` when redirecting to a saved URL after
  login. This should improve the behavior in mounted engines.

[1.4.0]: https://github.com/thoughtbot/clearance/compare/v1.3.0...v1.4.0

## [1.3.0] - March 14, 2014

### Added
- Installing Clearance with an existing User model will now create a migration
  that includes adding remember tokens to all existing user records.

[1.3.0]: https://github.com/thoughtbot/clearance/compare/v1.2.1...v1.3.0

## [1.2.1] - March 6, 2014

### Fixed
- Query string is now included in the redirect URL when Clearance redirects to a
  previously stored URL.

[1.2.1]: https://github.com/thoughtbot/clearance/compare/v1.2.0...v1.2.1

## [1.2.0] - February 28, 2014

### Added
- Support for Rails 4.1.0.rc1
- Sign in can now be disabled with `config.allow_sign_in = false`

### Changed
- Sign in failure message is now customized exclusively via I18n.
  `SessionsController#flash_failure_after_create` is no longer called. To
  customize the message, change the
  `clearance.controllers.sessions.bad_email_or_password` or
  `flashes.failure_after_create` key.

### Deprecated
- `clearance/testing` is now deprecated. Require `clearance/rspec` or
  `clearance/test_unit` as appropriate.

[1.2.0]: https://github.com/thoughtbot/clearance/compare/v1.1.0...v1.2.0

## [1.1.0] - November 21, 2013

### Added
- Validate email with `EmailValidator` [strict mode][strict].
- The `cookie_expiration` configuration lambda can now be called with  a
  `cookies` parameter. Allows the Clearance cookie expiration to be set
  according to the value of another cookie (such as `remember_me`).
- Allow cookie domain and path configuration.
- Add sign in guards.

[strict]: https://github.com/balexand/email_validator#strict-mode

### Fixed
- Don't allow logins with blank `remember_token`.

### Deprecated
- A `cookie_expiration` lambda that does not accept this `cookies`
  parameter has been deprecated.

[1.1.0]: https://github.com/thoughtbot/clearance/compare/v1.0.1...v1.1.0


## [1.0.1] - August 9, 2013

### Fixed
- Fix an issue when trying to sign in with `nil`

[1.0.1]: https://github.com/thoughtbot/clearance/compare/v1.0.0...v1.1.1

## [1.0.0] - August 1, 2013

### Added
- Support Rails 4.
- Speed up test suites using `::BCrypt::Engine::MIN_COST`.
- Speed up integration suites with `Clearance::BackDoor`.
- Provide `BCryptMigrationFromSHA1` password strategy to help people migrate from
  SHA1 (the old default password strategy) to BCrypt (the new default).
- Support Ruby 2.
- More extension points in more controllers.
- Add `SignedIn` and `SignedOut` routing constraints.
- Add a fake password strategy, which is useful when writing tests.
- Add `redirect_url` configuration option.
- Add `secure_cookie` configuration option.

### Changed
- Change default password strategy to BCrypt.
- Replace email regular expression with `EmailValidator` gem.
- Require > Ruby 1.9.
- The `email`, `encrypted_password`, and `remember_token` fields of the users
  table are `NOT NULL` in the default migration.
- Replace Cucumber feature generator with RSpec + Capybara.
- Remove Diesel dependency.
- `PasswordsController` `params[:user]` has changed to `params[:password_reset]`
  to avoid locale conflicts.

### Fixed
- Improve security when changing password.
- Reduce extra user lookups when adding cookie to headers.
- Unauthorized API requests return HTTP status 401 rather than a redirect
  to the sign in page.

### Removed
- Remove deprecated methods on User: `remember_me!`, `generate_random_code`,
  `password_required?`.
- Remove `unloadable` from controllers (Rails 4 bug fix in development
  environment).
- Remove support for supplying `return_to` value via request parameter.

[1.0.0]: https://github.com/thoughtbot/clearance/compare/v0.16.2...v1.0.0

## [0.16.2] - May 11, 2012

### Changed
- Change default email sender to `deploy@example.com`.

[0.16.2]: https://github.com/thoughtbot/clearance/compare/v0.16.1...v0.16.2

## [0.16.1] - April 16, 2012

### Fixed
- Behave correctly when Rails whitelist attributes mass assignment
  protection is turned on.
- Fix for Rails 3.2.x modifying the HTTP cookie headers in rack requests.

[0.16.1]: https://github.com/thoughtbot/clearance/compare/v0.16.0...v0.16.1

## [0.16.0] - March 16, 2012

### Added
- Blowfish password encryption strategy.

[0.16.0]: https://github.com/thoughtbot/clearance/compare/v0.15.0...v0.16.0

## [0.15.0] - February 3, 2012

### Added
- The `User` model can be swapped out using the `Clearance.configure` method.

### Removed
- Remove `User::InstanceMethods` to silence a Rails 3.2 deprecation warning.

[0.15.0]: https://github.com/thoughtbot/clearance/compare/v0.14.0...v0.15.0

## [0.14.0] - January 13, 2012

### Added
- Support clearance session management from the Rack environment.

[0.14.0]: https://github.com/thoughtbot/clearance/compare/v0.13.2...v0.14.0

## [0.13.2] - January 13, 2012

### Fixed
- Fixed the `deny_access` matcher.

[0.13.2]: https://github.com/thoughtbot/clearance/compare/v0.13.0...v0.13.2

## [0.13.0] - October 11, 2011

### Changed
- In Clearance's optional generated features, use pure Capybara instead of
  depending on Cucumber's removed `web_steps`, paths, and selectors.
- Extract SHA-1-specific code out of `User` into `PasswordStrategies` module.
- Extract sign in form so that other methods can be added easily.
- Test against Rails 3.1. Required upgrades to Diesel and Appraisal.

[0.13.0]: https://github.com/thoughtbot/clearance/compare/v0.12.0...v0.13.0

## [0.12.0] - June 30, 2011

### Changed
- Denying access redirects to `root_url` when signed in, `sign_in_url` when
  signed out.
- Using flash `:notice` key everywhere now instead of `:success` and `:failure`.
  More in line with Rails conventions.
- `redirect_back_or` on sign up.
- Resetting password no longer redirects to sign in page. It displays a message
  telling them to look for an email.
- Removed redundant flash messages. ("Signed in.", "Signed out.", and "You are
  now signed up.")

[0.12.0]: https://github.com/thoughtbot/clearance/compare/v0.11.2...v0.12.0

## [0.11.2] - June 29, 2011

### Added
- Rails 3.1.rc compatible.
- RSpec and Test::Unit compliant test matcher (`should deny_access`, etc)

### Removed
- No more Clearance `shoulda_macros`. Instead providing RSpec and
  Test::Unit-compliant test matchers (`should deny_access`, etc).

[0.11.2]: https://github.com/thoughtbot/clearance/compare/v0.11.1...v0.11.2

## [0.11.1] - April 30, 2011

### Added
- Redirect to home page after sign up.

### Fixed
- Removing `:case_sensitive` option from `validates_uniqueness_of`. It was
  unnecessary and causes a small performance problem on some apps.

### Removed
- Remove dependency on `dynamic_form`. Replaced with flashes due to limited number
  of failure cases.

[0.11.1]: https://github.com/thoughtbot/clearance/compare/v0.11.0...v0.11.1

## [0.11.0] - April 24, 2011

### Added
- New `controller#authenticate(params)` method. Redefine username & password or
  other styles of authentication.

### Changed
- `before_filter :authenticate` API replaced with more aptly-named `before_filter
  :authorize`.

### Removed
- Removing password confirmation.

[0.11.0]: https://github.com/thoughtbot/clearance/compare/v0.10.5...v0.11.0

## [0.10.5] - April 19, 2011

### Security
- Closing CSRF hole for Rails >= 3.0.4 apps.

[0.10.5]: https://github.com/thoughtbot/clearance/compare/v0.10.4...v0.10.5

## [0.10.4] - April 16, 2011

### Added
- Use HTML5 email fields.

### Changed
- Emails forced to be downcased (particularly for iPhone user case).

### Fixed
- Password reset requires a password.

### Removed
- Formtastic views generator removed.

[0.10.4]: https://github.com/thoughtbot/clearance/compare/v0.10.3.2...v0.10.4

## [0.10.3.2] - March 6, 2011

### Fixed
- Fix gemspec to include all necessary files.

[0.10.3.2]: https://github.com/thoughtbot/clearance/compare/v0.10.3.1...v0.10.3.2

## [0.10.3.1] - February 20, 2011

### Fixed
- Ensure everything within features inside any engine directory is included in
  the `gemspec`.

[0.10.3.1]: https://github.com/thoughtbot/clearance/compare/v0.10.3...v0.10.3.1

## [0.10.3] - February 19, 2011

### Fixed
- Include features/engines in `gemspec` file list so generator works as
  expected.

[0.10.3]: https://github.com/thoughtbot/clearance/compare/v0.10.2...v0.10.3

## [0.10.2] - February 18, 2011

### Added
- New generator command: `rails generate clearance:install`.
- When Clearance installed in an app that already has users, allow old users to
  sign in by resetting their password.

### Changed
- Step definitions are now prefixed with `visitor_` to use thoughtbot
  convention.

[0.10.2]: https://github.com/thoughtbot/clearance/compare/v0.10.1...v0.10.2

## [0.10.1] - February 9, 2011

### Fixed
- Replaced `ActionController::Forbidden` with a user-friendly flash message.

[0.10.1]: https://github.com/thoughtbot/clearance/compare/v0.10.0...v0.10.1

## [0.10.0] - June 29, 2010

### Added
- Better email validation regular expression.

### Removed
- Removed email confirmation step, was mostly a hassle and can always be added
  back in at the application level (instead of engine level) if necessary.
- Removed `disable_with` on forms since it does not allow IE users to submit
  forms. [Read more](https://github.com/rails/jquery-ujs/issues#issue/30).

[0.10.0]: https://github.com/thoughtbot/clearance/compare/v0.9.1...v0.10.0

## [0.9.1] - June 29, 2010

### Added
- This release supports Rails 3, capybara, and shoulda 2.10+.

[0.9.1]: https://github.com/thoughtbot/clearance/compare/v0.9.0...v0.9.1

## [0.9.0] - June 11, 2010

### Added
- Allow customization of cookie duration.

### Changed
- Removed unnecessary db index.

[0.9.0]: https://github.com/thoughtbot/clearance/compare/v0.8.8...v0.9.0

## [0.8.8] - February 25, 2010

### Fixed
- Fixed `sign_in` and `sign_out` not setting `current_user`.

[0.8.8]: https://github.com/thoughtbot/clearance/compare/v0.8.7...v0.8.8

## [0.8.7] - February 21, 2010

### Fixed
- Fixed global sign out bug.
- Allow Rails apps to `before_filter :authenticate` the entire app
  in `ApplicationController` and still have password recovery work without
  overriding any controllers.
- Rails 3 fix for `ActionController`/`ActionDispatch` change.

[0.8.7]: https://github.com/thoughtbot/clearance/compare/v0.8.6...v0.8.7

## [0.8.6] - February 17, 2010

### Added
- Allow overridden user models to skip email/password validations
  conditionally. This makes username/facebook integration easier.

### Fixed
- Clearance features capitalization should match view text.
- Skip `:authenticate before_filter` in controllers so apps can easily
  authenticate a whole site without subclassing.
- Added randomness to token and salt generation,
- Reset the `remember_token` on sign out instead of sign in. Allows for the same
  user to sign in from two locations at once.
- Append the version number to generated update migrations.

[0.8.6]: https://github.com/thoughtbot/clearance/compare/v0.8.5...v0.8.6

## [0.8.5] - January 20, 2010

### Changed
- Removed `attr_accessible` from `Clearance::User`.
- Remove dependency on `root_path`, use `'/'` instead.
- Use `Clearance.configure` block to set mailer sender instead of `DO_NOT_REPLY`
  constant.

### Fixed
- Replaced routing hack with `Clearance::Routes.draw(map)` to give more control
  to the application developer.
- Fixed bug in password reset feature.

[0.8.5]: https://github.com/thoughtbot/clearance/compare/v0.8.4...v0.8.5

## [0.8.4] - December 08, 2009

### Fixed
- Remove unnecessary `require 'factory_girl'` in generator.

[0.8.4]: https://github.com/thoughtbot/clearance/compare/v0.8.3...v0.8.4

## [0.8.3] - September 21, 2009

### Fixed
- Avoid possible collisions in the remember me token.

[0.8.3]: https://github.com/thoughtbot/clearance/compare/v0.8.2...v0.8.3

## [0.8.2] - September 01, 2009

### Added
- `current_user= accessor` method.
- Set `current_user` in `sign_in`.

[0.8.2]: https://github.com/thoughtbot/clearance/compare/v0.8.1...v0.8.2

## [0.8.1] - August 31, 2009

### Changed
- Removed unnecessary `remember_token_expires_at` column.

### Removed
- Removed `remember?` and `forget_me!` user instance methods.

[0.8.1]: https://github.com/thoughtbot/clearance/compare/v0.8.0...v0.8.1

## [0.8.0] - August 31, 2009

### Added
- Documented `Clearance::Authentication` with YARD.
- Documented `Clearance::User` with YARD.

### Changed
- Always remember me. Replaced session-and-remember-me authentication with
  always using a cookie with a long timeout.

[0.8.0]: https://github.com/thoughtbot/clearance/compare/v0.7.0...v0.8.0

## [0.7.0] - August 4, 2009

### Added
- Added `signed_out?` convenience method for controllers, helpers, views.
- Added `clearance_views` generator. By default, creates formtastic views which
  pass all tests and features.

### Fixed
- Redirect signed in user who clicks confirmation link again.
- Redirect signed out user who clicks confirmation link again.

[0.7.0]: https://github.com/thoughtbot/clearance/compare/v0.6.9...v0.7.0

## [0.6.9] - July 4, 2009

### Added
- Added timestamps to create users migration.
- Ready for Ruby 1.9.

[0.6.9]: https://github.com/thoughtbot/clearance/compare/v0.6.8...v0.6.9

## [0.6.8] - June 24, 2009

### Fixed
- Added `defined?` checks for various Rails constants such as `ActionController`
  for easier unit testing of Clearance extensions... particularly `ActiveRecord`
  extensions... `particularly strong_password`.

[0.6.8]: https://github.com/thoughtbot/clearance/compare/v0.6.7...v0.6.8

## [0.6.7] - June 13, 2009

### Added
- Added `sign_up`, `sign_in`, `sign_out` named routes.
- `flash_success_after_create`, `flash_notice_after_create`,
  `flash_failure_after_create`, `flash_sucess_after_update`,
  `flash_success_after_destroy`, etc.
- Added `#create` to forbidden `before_filters` on confirmations controller.

### Fixed
- `should_be_signed_in_as` shouldn't look in the session.

### Deprecated
- Deprecated `sign_user_in`. Told developers to use `sign_in` instead.

[0.6.7]: https://github.com/thoughtbot/clearance/compare/v0.6.6...v0.6.7

## [0.6.6] - May 18, 2009

### Fixed
- replaced `class_eval` in `Clearance::User` with modules. This was needed
  so we could write our own validations.

[0.6.6]: https://github.com/thoughtbot/clearance/compare/v0.6.5...v0.6.6

## [0.6.5] - May 17, 2009

### Added
- Make Clearance i18n aware.

[0.6.5]: https://github.com/thoughtbot/clearance/compare/v0.6.4...v0.6.5

## [0.6.4] - May 12, 2009

### Changed
- Replacing `sign_in_as` & `sign_out` shoulda macros with a stubbing (requires no
  dependency) approach. This will avoid dealing with the internals of
  `current_user`, such as session & cookies. Added `sign_in` macro which signs in an
  email confirmed user from clearance's factories.
- Move private methods on sessions controller into `Clearance::Authentication`
  module.
- Audited flash keys.

[0.6.4]: https://github.com/thoughtbot/clearance/compare/v0.6.3...v0.6.4

## [0.6.3] - April 23, 2009

### Fixed
- Scoping `ClearanceMailer` properly within controllers so it works in
  production environments.

[0.6.3]: https://github.com/thoughtbot/clearance/compare/v0.6.2...v0.6.3

## [0.6.2] - April 22, 2009

### Added
- Insert `Clearance::User` into User model if it exists.

[0.6.2]: https://github.com/thoughtbot/clearance/compare/v0.6.1...v0.6.2

## [0.6.1] - April 21, 2009

### Changed
- Scope operators are necessary to keep Rails happy. Reverting the original
  revert so they're back in the library now for constants referenced inside of
  the gem.

[0.6.1]: https://github.com/thoughtbot/clearance/compare/v0.6.0...v0.6.1

## [0.6.0] - April 21, 2009

### Changed
- Converted Clearance to a Rails engine.
- Include `Clearance::User` in User model in app.
- Include `Clearance::Authentication` in `ApplicationController`.
- Namespace controllers under `Clearance` module.
- Routes move to engine, use namespaced controllers but publicly the same.
- If you want to override a controller, subclass it like `SessionsController <
  Clearance::SessionsController`. This gives you access to usual hooks such as
  `url_after_create`.
- Controllers, mailer, model, routes all unit tested inside engine. Use
  `script/generate clearance_features` to test integration of Clearance with your
  Rails app. No longer including modules in your app's test files.
- Moved views to engine.
- Converted generated `test/factories/clearance.rb` to use inheritence for
  `email_confirmed_user`.
- Corrected some spelling errors with methods.
- Loading clearance routes after rails routes via some monkeypatching.
- Made the clearance controllers `unloadable` to stop constant loading errors in
  development mode.

[0.6.0]: https://github.com/thoughtbot/clearance/compare/v0.5.6...v0.6.0

## [0.5.6] - April 11, 2009

### Fixed
- Step definition changed for "User should see error messages" so features won't
  fail for certain validations.

[0.5.6]: https://github.com/thoughtbot/clearance/compare/v0.5.5...v0.5.6

## [0.5.5] - March 23, 2009

### Fixed
- Removing duplicate test to get rid of warning.

[0.5.5]: https://github.com/thoughtbot/clearance/compare/v0.5.4...v0.5.5

## [0.5.4] - March 21, 2009

### Changed
- When users fail logging in, redirect them instead of rendering.

[0.5.4]: https://github.com/thoughtbot/clearance/compare/v0.5.3...v0.5.4

## [0.5.3] - March 5, 2009

### Changed
- Clearance now works with (and requires) Shoulda 2.10.0.

[0.5.3]: https://github.com/thoughtbot/clearance/compare/v0.5.2...v0.5.3

## [0.5.2] - March 2, 2009

### Added
- Full compatible with Rails 2.3 (all tests pass)

[0.5.2]: https://github.com/thoughtbot/clearance/compare/v0.5.1...v0.5.2

## [0.5.1] - February 27, 2009

### Changed
- A user with unconfirmed email who resets password now confirms email.
- Switch order of cookies and sessions to take advantage of Rails 2.3's
  "Rack-based lazy-loaded sessions",
- Altered generator to interact with `application_controller.rb` instead of
  `application.rb` in Rails 2.3 apps.

### Fixed
- Rack-based session change altered how to test remember me cookie.

[0.5.1]: https://github.com/thoughtbot/clearance/compare/v0.5.0...v0.5.1

## [0.5.0] - February 27, 2009

### Fixed
- Fixed problem with Cucumber features.
- Fixed missing HTTP fluency use case.

[0.5.0]: https://github.com/thoughtbot/clearance/compare/v0.4.9...v0.5.0

## [0.4.9] - February 20, 2009

### Changed
- Protect passwords & confirmations actions with forbidden filters.
- Return 403 Forbidden status code in those cases.

### Security
- Fixed bug that allowed anyone to edit another user's password.

[0.4.9]: https://github.com/thoughtbot/clearance/compare/v0.4.8...v0.4.9

## [0.4.8] - February 16, 2009

### Added
- Added documentation for the flash.
- Generators `require 'test_helper'` instead of `File.join` for RR
  compatibility.

### Changed
- Removed interpolated email address from flash message to make i18n easier.
- Standardized flash messages that refer to email delivery.

[0.4.8]: https://github.com/thoughtbot/clearance/compare/v0.4.7...v0.4.8

## [0.4.7] - February 12, 2009

### Changed
- Removed `Clearance::Test::TestHelper` so there is one less setup step.
- All test helpers now in `shoulda_macros`.

[0.4.7]: https://github.com/thoughtbot/clearance/compare/v0.4.7...v0.4.7

## [0.4.6] - February 11, 2009

### Added
- Created `Actions` and `PrivateMethods` modules on controllers for future RDoc
  reasons.

[0.4.6]: https://github.com/thoughtbot/clearance/compare/v0.4.5...v0.4.6

## [0.4.5] - February 9, 2009

### Added
- Added password reset feature to `clearance_features` generator.

### Changed
- Only store location for `session[:return_to]` for GET requests.
- Audited "sign up" naming convention. "Register" had slipped in a few places.
- Switched to `SHA1` encryption. Cypher doesn't matter much for email
  confirmation, password reset. Better to have shorter hashes in the emails for
  clients who line break on 72 chars.

### Removed
- Removed email downcasing because local-part is case sensitive per
  RFC5321.
- Removed unnecessary `session[:salt]`.

[0.4.5]: https://github.com/thoughtbot/clearance/compare/v0.4.4...v0.4.5

## [0.4.4] - February 2, 2009

### Added
- Added a generator for Cucumber features.

### Changed
- Standardized naming for "Sign up," "Sign in," and "Sign out".

[0.4.4]: https://github.com/thoughtbot/clearance/compare/v0.3.7...v0.4.4
