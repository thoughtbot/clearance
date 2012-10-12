require 'rails/all'

module Clearance
  module Testing
    APP_ROOT = File.expand_path('..', __FILE__).freeze

    class Application < Rails::Application
      config.encoding = "utf-8"
      config.action_mailer.default_url_options = { :host => 'localhost' }

      if Rails::VERSION::MAJOR >= 3 && Rails::VERSION::MINOR >= 1
        config.paths['config/database'] = "#{APP_ROOT}/config/database.yml"
        config.paths['config/routes'] << "#{APP_ROOT}/config/routes.rb"
        config.paths['app/controllers'] << "#{APP_ROOT}/app/controllers"
        config.paths['app/views'] << "#{APP_ROOT}/app/views"
        config.paths['log'] = "tmp/log/development.log"
        config.assets.enabled = true
      else
        config.paths.config.database = "#{APP_ROOT}/config/database.yml"
        config.paths.config.routes << "#{APP_ROOT}/config/routes.rb"
        config.paths.app.controllers << "#{APP_ROOT}/app/controllers"
        config.paths.app.views << "#{APP_ROOT}/app/views"
        config.paths.log = "tmp/log"
      end

      config.cache_classes = true
      config.whiny_nils = true
      config.consider_all_requests_local = true
      config.action_controller.perform_caching = false
      config.action_dispatch.show_exceptions = false
      config.action_controller.allow_forgery_protection = false
      config.action_mailer.delivery_method = :test
      config.active_support.deprecation = :stderr
      config.secret_token = "SECRET_TOKEN_IS_MIN_30_CHARS_LONG"

      def require_environment!
        initialize!
      end

      def initialize!
        FileUtils.mkdir_p(Rails.root.join("db").to_s)
        super unless @initialized
      end
    end
  end
end
