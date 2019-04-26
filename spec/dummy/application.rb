require "rails/all"
require "clearance"

module Dummy
  APP_ROOT = File.expand_path("..", __FILE__).freeze

  I18n.enforce_available_locales = true

  class Application < Rails::Application
    config.action_controller.allow_forgery_protection = false
    config.action_controller.perform_caching = false
    config.action_dispatch.show_exceptions = false
    config.action_mailer.default_url_options = { host: "dummy.example.com" }
    config.action_mailer.delivery_method = :test
    config.active_support.deprecation = :stderr
    config.active_support.test_order = :random
    config.cache_classes = true
    config.consider_all_requests_local = true
    config.eager_load = false
    config.encoding = "utf-8"
    config.paths["app/controllers"] << "#{APP_ROOT}/app/controllers"
    config.paths["app/models"] << "#{APP_ROOT}/app/models"
    config.paths["app/views"] << "#{APP_ROOT}/app/views"
    config.paths["config/database"] = "#{APP_ROOT}/config/database.yml"
    config.paths["log"] = "tmp/log/development.log"

    config.paths.add "config/routes.rb", with: "#{APP_ROOT}/config/routes.rb"
    config.secret_key_base = "SECRET_KEY_BASE"

    if config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer)
      if Rails::VERSION::MAJOR < 6
        config.active_record.sqlite3.represent_boolean_as_integer = true
      end
    end

    if Rails::VERSION::MAJOR >= 6
      config.action_mailer.delivery_job = "ActionMailer::MailDeliveryJob"
    end

    config.active_job.queue_adapter = :inline

    def require_environment!
      initialize!
    end

    def initialize!(&block)
      FileUtils.mkdir_p(Rails.root.join("db").to_s)
      super unless @initialized
    end
  end
end
