# Clearance

[![Build Status](https://secure.travis-ci.org/thoughtbot/clearance.svg)](http://travis-ci.org/thoughtbot/clearance?branch=master)
[![Code Climate](https://codeclimate.com/github/thoughtbot/clearance.svg)](https://codeclimate.com/github/thoughtbot/clearance)
[![Documentation Quality](https://inch-ci.org/github/thoughtbot/clearance.svg?branch=master)](https://inch-ci.org/github/thoughtbot/clearance)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

Rails authentication with email & password.

Clearance is intended to be small, simple, and well-tested. It has opinionated
defaults but is intended to be easy to override.

Please use [GitHub Issues] to report bugs. If you have a question about the
library, please use the `clearance` tag on [Stack Overflow]. This tag is
monitored by contributors.

[GitHub Issues]: https://github.com/thoughtbot/clearance/issues
[Stack Overflow]: http://stackoverflow.com/questions/tagged/clearance

## Getting Started

Clearance is a Rails engine tested against Rails `>= 5.0` and Ruby `>= 2.4.0`.

You can add it to your Gemfile with:

```sh
gem "clearance"
```

Run the bundle command to install it.

After you install Clearance, you need to run the generator:

```shell
rails generate clearance:install
```

The Clearance install generator:

* Inserts `Clearance::User` into your `User` model
* Inserts `Clearance::Controller` into your `ApplicationController`
* Creates an initializer file to allow further configuration.
* Creates a migration file that either create a users table or adds any necessary
  columns to the existing table.

## Configure

Override any of these defaults in `config/initializers/clearance.rb`:

```ruby
Clearance.configure do |config|
  config.allow_sign_up = true
  config.cookie_domain = ".example.com"
  config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
  config.cookie_name = "remember_token"
  config.cookie_path = "/"
  config.routes = true
  config.httponly = false
  config.mailer_sender = "reply@example.com"
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  config.redirect_url = "/"
  config.rotate_csrf_on_sign_in = true
  config.secure_cookie = false
  config.sign_in_guards = []
  config.user_model = "User"
  config.parent_controller = "ApplicationController"
end
```

## Use

### Access Control

Use the `require_login` filter to control access to controller actions.

```ruby
class ArticlesController < ApplicationController
  before_action :require_login

  def index
    current_user.articles
  end
end
```

Clearance also provides routing constraints that can be used to control access
at the routing layer:

```ruby
Blog::Application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    root to: "admin/dashboards#show", as: :admin_root
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: "dashboards#show", as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "marketing#index"
  end
end
```

### Helper Methods

Use `current_user`, `signed_in?`, and `signed_out?` in controllers, views, and
helpers. For example:

```erb
<% if signed_in? %>
  <%= current_user.email %>
  <%= button_to "Sign out", sign_out_path, method: :delete %>
<% else %>
  <%= link_to "Sign in", sign_in_path %>
<% end %>
```

### Password Resets

When a user resets their password, Clearance delivers them an email. You
should change the `mailer_sender` default, used in the email's "from" header:

```ruby
Clearance.configure do |config|
  config.mailer_sender = "reply@example.com"
end
```

### Multiple Domain Support

You can support multiple domains, or other special domain configurations by
optionally setting `cookie_domain` as a callable object. The first argument
passed to the method is an ActionDispatch::Request object.

```ruby
Clearance.configure do |config|
  config.cookie_domain = lambda { |request| request.host }
end
```

### Integrating with Rack Applications

Clearance adds its session to the Rack environment hash so middleware and other
Rack applications can interact with it:

```ruby
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
```

## Overriding Clearance

### Routes

See [config/routes.rb](/config/routes.rb) for the default set of routes.

As of Clearance 1.5 it is recommended that you disable Clearance routes and take
full control over routing and URL design. This ensures that your app's URL design
won't be affected if the gem's routes and URL design are changed.

To disable the routes, change the `routes` configuration option to false:

```ruby
Clearance.configure do |config|
  config.routes = false
end
```

You can optionally run `rails generate clearance:routes` to dump a copy of the
default routes into your application for modification.

### Controllers

See [app/controllers/clearance](/app/controllers/clearance) for the default
behavior. Many protected methods were extracted in these controllers in an
attempt to make overrides and hooks simpler.

To override a Clearance controller, subclass it and update the routes to
point to your new controller (see the "Routes" section).

```ruby
class PasswordsController < Clearance::PasswordsController
class SessionsController < Clearance::SessionsController
class UsersController < Clearance::UsersController
```

### Redirects

The post-action redirects in Clearance are simple methods which can be
overridden one by one, or configured globally.

These "success" methods are called for signed in users, and redirect to
`Clearance.configuration.redirect_url` (which is `/` by default):

- `passwords#url_after_update`
- `sessions#url_after_create`
- `sessions#url_for_signed_in_users`
- `users#url_after_create`
- `application#url_after_denied_access_when_signed_in`

To override them all at once, change the global configuration of `redirect_url`.
To change individual URLs, override the appropriate method in your subclassed
controller.

These "failure" methods are called for signed out sessions:

- `application#url_after_denied_access_when_signed_out`
- `sessions#url_after_destroy`

They both default to `sign_in_url`. Override this method to change both of their
behavior, or override them individually to just change one.

### Views

See [app/views](/app/views) for the default behavior.

To override a view, create your own copy of it:

```
app/views/clearance_mailer/change_password.html.erb
app/views/passwords/create.html.erb
app/views/passwords/edit.html.erb
app/views/passwords/new.html.erb
app/views/sessions/_form.html.erb
app/views/sessions/new.html.erb
app/views/users/_form.html.erb
app/views/users/new.html.erb
```

You can use the Clearance views generator to copy the default views to your
application for modification.

```shell
rails generate clearance:views
```

### Layouts

By default, Clearance uses your application's default layout. If you would like
to change the layout that Clearance uses when rendering its views, simply
specify the layout in the `config/application.rb`

```ruby
config.to_prepare do
  Clearance::PasswordsController.layout "my_passwords_layout"
  Clearance::SessionsController.layout "my_sessions_layout"
  Clearance::UsersController.layout "my_admin_layout"
end
```

### Translations

All flash messages and email subject lines are stored in [i18n translations].
Override them like any other translation.

[i18n translations]: http://guides.rubyonrails.org/i18n.html

See [config/locales/clearance.en.yml](/config/locales/clearance.en.yml) for the
default behavior.

You can also install [clearance-i18n](https://github.com/thoughtbot/clearance-i18n)
for access to additional, user-contributed translations.

### User Model

See [lib/clearance/user.rb](/lib/clearance/user.rb) for the default behavior.
You can override those methods as needed.

Note that there are some model-level validations (see above link for detail)
which the `Clearance::User` module will add to the configured model class and
which may conflict with or duplicate already present validations on the `email`
and `password` attributes. Over-riding the `email_optional?` or
`skip_password_validation?` methods to return `true` will disable those
validations from being added.

### Deliver Email in Background Job

Clearance has a password reset mailer. If you are using Rails 4.2 and Clearance
1.6 or greater, Clearance will use ActiveJob's `deliver_later` method to
automatically take advantage of your configured queue.

If you are using an earlier version of Rails, you can override the
`Clearance::Passwords` controller and define the behavior you need in the
`deliver_email` method.

```ruby
class PasswordsController < Clearance::PasswordsController
  def deliver_email(user)
    ClearanceMailer.delay.change_password(user)
  end
end
```

## Extending Sign In

By default, Clearance will sign in any user with valid credentials. If you need
to support additional checks during the sign in process then you can use the
SignInGuard stack. For example, using the SignInGuard stack, you could prevent
suspended users from signing in, or require that users confirm their email
address before accessing the site.

`SignInGuard`s offer fine-grained control over the process of
signing in a user. Each guard is run in order and hands the session off to
the next guard in the stack.

A `SignInGuard` is an object that responds to `call`. It is initialized with a
session and the current stack.

On success, a guard should call the next guard or return `SuccessStatus.new` if
you don't want any subsequent guards to run.

On failure, a guard should call `FailureStatus.new(failure_message)`. It can
provide a message explaining the failure.

For convenience, a [SignInGuard](lib/clearance/sign_in_guard.rb) class has been
provided and can be inherited from. The convenience class provides a few methods
to help make writing guards simple: `success`, `failure`, `next_guard`,
`signed_in?`, and `current_user`.

Here's an example custom guard to handle email confirmation:

```ruby
Clearance.configure do |config|
  config.sign_in_guards = [EmailConfirmationGuard]
end
```

```ruby
class EmailConfirmationGuard < Clearance::SignInGuard
  def call
    if unconfirmed?
      failure("You must confirm your email address.")
    else
      next_guard
    end
  end

  def unconfirmed?
    signed_in? && !current_user.confirmed_at
  end
end
```

## Testing

### Fast Feature Specs

Clearance includes middleware that avoids wasting time spent visiting, loading,
and submitting the sign in form. It instead signs in the designated user
directly. The speed increase can be [substantial][backdoor].

[backdoor]: http://robots.thoughtbot.com/post/37907699673/faster-tests-sign-in-through-the-back-door

Enable the Middleware in Test:

```ruby
# config/environments/test.rb
MyRailsApp::Application.configure do
  # ...
  config.middleware.use Clearance::BackDoor
  # ...
end
```

Usage:

```ruby
visit root_path(as: user)
```

Additionally, if `User#to_param` is overridden, you can pass a block in
order to override the default behavior:

```ruby
# config/environments/test.rb
MyRailsApp::Application.configure do
  # ...
  config.middleware.use Clearance::BackDoor do |username|
    Clearance.configuration.user_model.find_by(username: username)
  end
  # ...
end
```

### Ready Made Feature Specs

If you're using RSpec, you can generate feature specs to help prevent
regressions in Clearance's integration with your Rails app over time. These
feature specs, will also require `factory_bot_rails`.

To Generate the clearance specs, run:

```shell
rails generate clearance:specs
```

### Controller Test Helpers

To test controller actions that are protected by `before_action :require_login`,
require Clearance's test helpers in your test suite.

For `rspec`, add the following line to your `spec/rails_helper.rb` or
`spec/spec_helper` if `rails_helper` does not exist:

```ruby
require "clearance/rspec"
```

For `test-unit`, add this line to your `test/test_helper.rb`:

```ruby
require "clearance/test_unit"
```

**Note for Rails 5:** the default generated controller tests are now
integration tests. You will need to use the
[backdoor middleware](#fast-feature-specs) instead.

This will make `Clearance::Controller` methods work in your controllers
during functional tests and provide access to helper methods like:

```ruby
sign_in
sign_in_as(user)
sign_out
```

### View and Helper Spec Helpers

Does the view or helper you're testing reference `signed_in?`, `signed_out?` or
`current_user`? If you `require 'clearance/rspec'`, you will have the following
helpers available in your view specs:

```ruby
sign_in
sign_in_as(user)
```

These will make the clearance view helpers work as expected by signing in either
a new instance of your user model (`sign_in`) or the object you pass to
`sign_in_as`. If you do not call one of these sign in helpers or otherwise set
`current_user` in your view specs, your view will behave as if there is no
current user: `signed_in?` will be false and `signed_out?` will be true.

## Contributing

Please see [CONTRIBUTING.md].
Thank you, [contributors]!

[CONTRIBUTING.md]: /CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/clearance/graphs/contributors

## License

Clearance is copyright © 2009-2019 thoughtbot. It is free software, and may be
redistributed under the terms specified in the [`LICENSE`] file.

[`LICENSE`]: /LICENSE

## About thoughtbot

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

Clearance is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community] or
[hire us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
