require "clearance"
require "rails"

module Clearance
  # Makes Clearance behavior available to Rails apps on initialization. By using
  # a Rails Engine rather than a Railtie, Clearance can automatically expose its
  # own routes and views to the hosting application.
  #
  # Requiring `clearance` (likely by having it in your `Gemfile`) will
  # automatically require the engine. You can opt-out of Clearance's internal
  # routes by using {Configuration#routes=}. You can override the Clearance
  # views by running `rails generate clearance:views`.
  #
  # In addition to providing routes and views, the Clearance engine:
  #
  # * Ensures `password` and `token` parameters are filtered out of Rails logs.
  # * Mounts the {RackSession} middleware in the appropriate location
  # * Reloads classes referenced in your {Configuration} on every request in
  #   development mode.
  #
  class Engine < Rails::Engine
    initializer "clearance.filter" do |app|
      app.config.filter_parameters += [:password, :token]
    end

    config.app_middleware.use(Clearance::RackSession)

    config.to_prepare do
      Clearance.configuration.reload_user_model
    end
  end
end
