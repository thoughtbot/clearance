# CHANGELOG

The noteworthy changes for each Clearance version are included here. For a
complete changelog, see the git history for each version via the version links.

## [Unreleased]

[Unreleased]: https://github.com/thoughtbot/clearance/compare/v2.10.0...main

## [2.10.0] - March 28, 2025
- Drop support for Rails 7.0 and Ruby 3.1 (#1045)

[2.10.0]: https://github.com/thoughtbot/clearance/compare/v2.9.3...v2.10.0

## [2.9.3] - November 26, 2024
- Add Rails 8 to testing matrix (#1038) Hamed Asghari

[2.9.3]: https://github.com/thoughtbot/clearance/compare/v2.9.2...v2.9.3

## [2.9.2] - November 14, 2024
- Fix query params being clobbered by Clearance::BackDoor (#1041) Frederick Cheung

[2.9.2]: https://github.com/thoughtbot/clearance/compare/v2.9.1...v2.9.2

## [2.9.1] - October 29, 2024
 - Update gemspec

[2.9.1]: https://github.com/thoughtbot/clearance/compare/v2.9.0...v2.9.1

## [2.9.0] - October 29, 2024
- Added Rails 7.2 and Ruby 3.3 to testing matrix
  and overhauled dummy app (#1032) Hamed Asghari
- Droped support for Ruby 3.0 and Rails 6.1 (#1036)

[2.9.0]: https://github.com/thoughtbot/clearance/compare/v2.8.0...v2.9.0

## [2.8.0] - August 9, 2024
- Feature: Added allow_password_resets config option (#1019) Jos O'shea
- Added dependabot (#1028) Karine Vieira
- Fixed some deprecation warnings (#1018)
- Added a dynamic workflow to update SECURITY.md

[2.8.0]: https://github.com/thoughtbot/clearance/compare/v2.7.2...v2.8.0

## [2.7.2] - June 28, 2024
- Fix method redefinition and circular require issues (#1027)
- Add specs for email validator strict mode (#1001)
- Create SECURITY.md (#972)
- Fix validating email in strict mode (#976)
- Update the example config in README.md (#977)
- Remove Hound README badge (#1020)

[2.7.2]: https://github.com/thoughtbot/clearance/compare/v2.7.1...v2.7.2

## [2.7.1] - May 8, 2024
- Update sqlite3 and erb_lint gems (#1017) Jos O'shea

[2.7.1]: https://github.com/thoughtbot/clearance/compare/v2.7.0...v2.7.1

## [2.7.0] - April 19, 2024
- Call dynamic README workflow (#1004)
- Drop Ruby 2.76 and Rails 6.0 (#1005)
- Update specs to match on translations (#1015)
- Add configuration options for failure method redirects (#1002) Dan Sharp

[2.7.0]: https://github.com/thoughtbot/clearance/compare/v2.6.2...v2.7.0

## [2.6.2] - January 15, 2024
- Fix typo in Clearance::Token docs (#1000) Gabe Berke-Williams
- Add CODEOWNERS file (#994)
- Add support for Rails 7.1 (#995) Samuel Giddens
- Fix for setup & CI for Rails 7.1 support, update "MiniTest" to "Minitest",
add handling for different versions of Rack::Utils.set_cookie_header!, remove
deprecated active record handling in application.rb (#998)
- Update argon2 to v2.2.0 (#989) Georg Leciejewski
- Prefer literal hash creation notation (#984) Ivan Marynych
- Add Ruby 3.2.2 to testing matrix (#991)
- Replace mentions of NEWS.md with CHANGELOG.md (#982)
- Fix broken thoughtbot logo on README.md

[2.6.2]: https://github.com/thoughtbot/clearance/compare/v2.6.1...v2.6.2

## [2.6.1] - September 23, 2022
- Document how to report security issues
- Only update the `env["QUERY_STRING"]` if the `as` parameter is present in
  backdoor middleware

[2.6.1]: https://github.com/thoughtbot/clearance/compare/v2.6.0...v2.6.1

## [2.6.0] - June 12, 2022

- Drops support for Rails 5.0, 5.1 and 5.2, see https://endoflife.date/rails #964
- Drops support for Ruby 2.4, 2.5 and 2.6, see https://endoflife.date/ruby #964
- Adds support for Turbo with appropriate status codes #965
- Adds unique constraints on `remember_token` and `confirmation_token` #966
- Allows `user_parameter` to be configuration, e.g. `params[:custom_id]` instead of
  `params[:user_id]` #782 (Bryan Marble)
- Updates SignInGuard documentation #950 (Matthew LS)
- Forward options in redirect_back_or helper (#968) (Matthew LS)
- Add configuration option to disable sign in after password reset (#969) (Till
  Prochaska)

[2.6.0]: https://github.com/thoughtbot/clearance/compare/v2.5.0...v2.6.0

## [2.5.0] - September 10, 2021

### Fixed

- Fix open redirect vulnerability

### Changed

- Rename default branch to `main`

[2.5.0]: https://github.com/thoughtbot/clearance/compare/v2.4.0...v2.5.0

## [2.4.0] - March 5, 2021

### Added

- Optionally use signed cookies to prevent remember token timing attacks

[2.4.0]: https://github.com/thoughtbot/clearance/compare/v2.3.1...v2.4.0

## [2.3.1] - March 5, 2021

### Fixed

- Support for accessing Rails 6.x primary_key_type in generator.
- Fix password reset URLs when using a custom model
- Fix flaky test that relied on too specific time delta
- Revert case sensitivity for email uniqueness
- Bump nokogiri and actionview dependencies to address security vulnerabilities

[2.3.1]: https://github.com/thoughtbot/clearance/compare/v2.3.0...v2.3.1

## [2.3.0] - August 14, 2020

### Fixed

- Delete cookie correctly when a callable object is set as the custom domain
  setting.
- Strip `as` parameter when signing in through the back door.
- Remove broken autoload for deprecated password strategies.

### Changed

- Deliver password reset email inline rather than in the background.
- Remove unnecessary unsafe interpolation in erb templates.

[2.3.0]: https://github.com/thoughtbot/clearance/compare/v2.2.0...v2.3.0

## [2.2.1] - August 7, 2020

### Fixed

- Prevent user enumeration by timing attacks. Trying to log in with an
  unrecognized email address will now take the same amount of time as for a user
  that does exist in the system.

[2.2.1]: https://github.com/thoughtbot/clearance/compare/v2.2.0...v2.2.1

## [2.2.0] - July 9, 2020

### Added

- Add an Argon2 password strategy

### Fixed

- Use strings instead of classes on guard classes, avoids Rails deprecation
  warning.
- Use `find_by` style for finders, improves neo4j support
- Provide explicit case sensitivity option for email uniqueness, avoid Rails
  deprecation warning.

[2.2.0]: https://github.com/thoughtbot/clearance/compare/v2.1.0...v2.2.0

## [2.1.0] - December 19, 2019

### Added

- Add a `parent_controller` configuration option to specify the controller that
  Clearance's `BaseController` will inherit from. Defaults to a value of
  `ApplicationController`.
- Use the configured `primary_key_type` from the Active Record settings of the
  project including Clearance, if it is set, while generating migrations. For
  example, a setting of `:uuid` in a Rails app using Clearance will cause the
  clearance-generated migrations to use this for the `users` table id type.

### Fixed

- Delete cookies correctly when a custom domain setting is being used.
- Do not set the authorization cookie on requests which did not exercise the
  authorization code. Reduces the chances of leaving an auth cookie in a
  publicly cacheable page that didn't require authorization to access.

### Changed

- Update the `email_validator` gem to a newer version embrace the more relaxed
  email validation options which it now defaults to.
- When a password reset request is submitted without an email address, a flash
  alert is now provided. Previously this continued silently as though it had
  worked. We still proceed that way when there is an invalid (but present)
  value, so as not to reveal existent vs. non-existent emails in the database.

### Removed

- Remove an unused route to `passwords#create` nested under `users`.
- No longer include the (rarely used in practice) application layout as part of
  the views installer; but continue to provide some stock sign-in/out and flash
  partial code in the gem installation README output.

### Deprecated

- Remove the existing deprecation notice around the `rotate_csrf_on_sign_in`
  setting, and make that setting default to true.

[2.1.0]: https://github.com/thoughtbot/clearance/compare/v2.0.0...v2.1.0

## [2.0.0] - November 12, 2019

### Added

- Add support for Rails version 6
- Allow `cookie_domain` to be configured with a lambda for custom configuration
- Add ability to configure BCrypt computational cost of hash calculation.
- Add `same_site` configuration option for increased CSRF protection.

### Fixed

- Fix issue where invalid params could raise `NoMethodError` when updating and
  resetting passwords.
- The backdoor auth mechanism now supports scenarios where `Rails.env` has been
  configured via env variables other than `RAILS_ENV` (`RACK_ENV` for example).

### Removed

- Removed support for Ruby versions older than 2.4
- Removed support for Rails versions older than 5.0
- Removed all deprecated code from Clearance 1.x

### Changed

- Flash messages now use `flash[:alert]` rather than `flash[:notice]` as they
  were used as errors more often than notices.

[2.0.0]: https://github.com/thoughtbot/clearance/compare/v1.17.0...v2.0.0

## [1.17.0] - April 11, 2019

### Changed

- Update the `HttpOnly` cookie setting for the remember token to default to
  true, which prevents the value from being available to JavaScript.
- Add configuration option to allow the auth backdoor to work in specified
  environments (defaults to `test`, `development`, `ci`).

[1.17.0]: https://github.com/thoughtbot/clearance/compare/v1.16.2...1.17.0

## [1.16.2] - February 25, 2019

### Fixed

- Added missing translation keys
- Fix issue where a cookie value could be set more than once when interacting
  with the `httponly` option

### Changed

- Remove Rails as a dependency so that clearance does not trigger a cascade of
  requirements as rails pulls in every framework. Instead, depend on just the
  frameworks relevant to Clearance.
- Prevent `Clearance::BackDoor` from being used outside the "test" environment.

[1.16.2]: https://github.com/thoughtbot/clearance/compare/v1.16.1...v1.16.2

## [1.16.1] - November 2, 2017

### Fixed

- Fixed issue where tokens from abandoned password reset attempts were stored in
  the session, preventing newly generated password reset tokens from working.
- Improve compatibility with Rails API projects by calling `helper_method` only
  when it is defined.
- URL fragment in server-set `session[:return_to]` values are preserved when
  redirecting to the stored value.
- Eliminated deprecation in Clearance test helpers that were related to the
  renaming of FactoryGirl to FactoryBot.

[1.16.1]: https://github.com/thoughtbot/clearance/compare/v1.16.0...v1.16.1

## [1.16.0] - January 16, 2017

### Security

- Clearance users can now help prevent [session fixation attacks] by setting
  `Clearance.configuration.rotate_csrf_on_sign_in` to `true`. This will cause
  the user's CSRF token to be rotated on sign in and is recommended for all
  Clearance applications. This setting will default to `true` in Clearance 2.0.
  Clearance will emit a warning on each sign in until this configuration setting
  is explicitly set to `true` or `false`.

[session fixation attacks]: https://www.owasp.org/index.php/Session_fixation
[1.16.0]: https://github.com/thoughtbot/clearance/compare/v1.15.1...v1.16.0

## [1.15.1] - October 6, 2016

### Fixed

- Password reset form redirect no longer uses a named route helper, which means
  it will work for developers that have customized their routes.

[1.15.1]: https://github.com/thoughtbot/clearance/compare/v1.15.0...v1.15.1

## [1.15.0] - September 26, 2016

### Security

- Prevent possible password reset token leak to external sites linked to on the
  password reset page. See [PR #707] for more information.

[pr #707]: https://github.com/thoughtbot/clearance/pull/707
[1.15.0]: https://github.com/thoughtbot/clearance/compare/v1.14.2...v1.15.0

## [1.14.2] - August 10, 2016

### Fixed

- Fixed incompatibility with `attr_encrypted` gem by inlining the body of the
  `encrypt` helper method used in the BCrypt password strategy.

[1.14.2]: https://github.com/thoughtbot/clearance/compare/v1.14.1...v1.14.2

## [1.14.1] - May 12, 2016

### Fixed

- Fixed insertion of `include Clearance::User` when running the install
  generator in an app that already has a `User` model.
- Updated `deny_access` matcher to assert against configured redirect location
  rather than hard coded `/`.

[1.14.1]: https://github.com/thoughtbot/clearance/compare/v1.14.0...v1.14.1

## [1.14.0] - April 29, 2016

### Added

- `Clearance::BackDoor` now accepts a block, allowing the user for a test to be
  looked up by a parameter other than `id` if you have overridden `to_param` for
  the `User` model.

### Fixed

- We now correctly track the dirty state of `User#encrypted_password`, which
  fixes custom validations on `User#password` (e.g. validating password length)
  that were conditional on the password actually changing.
- The `clearance:install` generator will now generate a `User` model that
  inherits from `ApplicationRecord` if run on a Rails 5 app that doesn't already
  have a `User` model.

### Deprecated

- `User#password_changing` is deprecated in favor of automatic dirty tracking on
  `encrypted_password` and `password`. If you are calling this in your
  application you should be able to remove it.

[1.14.0]: https://github.com/thoughtbot/clearance/compare/v1.13.0...v1.14.0

## [1.13.0] - March 4, 2016

### Added

- Clearance now supports Rails 5.0.0.beta3 and newer.

### Fixed

- Clearance will now infer the parameter name to use when accessing user
  parameters in a request. This previously used `:user`, which was incorrect for
  customized user models.
- Generated feature specs no longer rely on RSpec monkey patches.

[1.13.0]: https://github.com/thoughtbot/clearance/compare/v1.12.1...v1.13.0

## [1.12.1] - January 7, 2016

### Fixed

- Fixed the `create_users` migration generated
  by `rails generate clearance:install` under Rails 3.x.

[1.12.1]: https://github.com/thoughtbot/clearance/compare/v1.12.0...v1.12.1

## [1.12.0] - November 17, 2015

### Added

- Users will now see a flash message when redirected to sign in by
  `require_login`. This I18n key for this message is
  `flashes.failure_when_not_signed_in` and defaults to "Please sign in to
  continue".
- Added significant API documentation. API documentation effort is ongoing.

### Fixed

- Fixed expectation in the generated `visitor_resets_password_spec.rb` file.
- Corrected indentation of routes inserted by the routes generator.
- Corrected indentation of `include Clearance::User` when the install generator
  adds it to an existing user class.

[1.12.0]: https://github.com/thoughtbot/clearance/compare/v1.11.0...v1.12.0

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
- The `cookie_expiration` configuration lambda can now be called with a
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

- `before_filter :authenticate` API replaced with more
  aptly-named `before_filter :authorize`.

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

- Replacing `sign_in_as` & `sign_out` shoulda macros with a stubbing (requires
  no dependency) approach. This will avoid dealing with the internals of
  `current_user`, such as session & cookies. Added `sign_in` macro which signs
  in an email confirmed user from clearance's factories.
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
- If you want to override a controller, subclass it like
  `SessionsController < Clearance::SessionsController`. This gives you access to
  usual hooks such as `url_after_create`.
- Controllers, mailer, model, routes all unit tested inside engine. Use
  `script/generate clearance_features` to test integration of Clearance with your
  Rails app. No longer including modules in your app's test files.
- Moved views to engine.
- Converted generated `test/factories/clearance.rb` to use inheritance for
  `email_confirmed_user`.
- Corrected some spelling errors with methods.
- Loading clearance routes after rails routes via some monkey patching.
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
