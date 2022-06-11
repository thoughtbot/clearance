require "rails/all"

require "clearance"

module Dummy
  APP_ROOT = File.expand_path("..", __FILE__).freeze

  class Application < Rails::Application
    config.action_controller.perform_caching = false
    config.action_mailer.default_url_options = { host: "dummy.example.com" }
    config.action_mailer.delivery_method = :test
    config.active_support.deprecation = :stderr
    config.eager_load = false

    config.paths["app/controllers"] << "#{APP_ROOT}/app/controllers"
    config.paths["app/models"] << "#{APP_ROOT}/app/models"
    config.paths["app/views"] << "#{APP_ROOT}/app/views"
    config.paths["config/database"] = "#{APP_ROOT}/config/database.yml"
    config.paths["log"] = "tmp/log/development.log"
    config.paths.add "config/routes.rb", with: "#{APP_ROOT}/config/routes.rb"

    if Rails.version.match?(/^6.0/)
      config.active_record.sqlite3.represent_boolean_as_integer = true
    else
      config.active_record.legacy_connection_handling = false
    end

    def require_environment!
      initialize!
    end

    def initialize!(&block)
      super unless @initialized
    end
  end
end
