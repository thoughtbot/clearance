require 'rails/all'

module Clearance
  module Testing
    APP_ROOT = File.expand_path('..', __FILE__).freeze

    def self.rails4?
      Rails::VERSION::MAJOR == 4
    end

    class Application < Rails::Application
      config.action_controller.allow_forgery_protection = false
      config.action_controller.perform_caching = false
      config.action_dispatch.show_exceptions = false
      config.action_mailer.default_url_options = { :host => 'localhost' }
      config.action_mailer.delivery_method = :test
      config.active_support.deprecation = :stderr
      config.assets.enabled = true
      config.cache_classes = true
      config.consider_all_requests_local = true
      config.eager_load = false
      config.encoding = 'utf-8'
      config.paths['app/controllers'] << "#{APP_ROOT}/app/controllers"
      config.paths['app/views'] << "#{APP_ROOT}/app/views"
      config.paths['config/database'] = "#{APP_ROOT}/config/database.yml"
      config.paths['log'] = 'tmp/log/development.log'
      config.secret_token = 'SECRET_TOKEN_IS_MIN_30_CHARS_LONG'

      if Clearance::Testing.rails4?
        config.paths.add 'config/routes.rb', with: "#{APP_ROOT}/config/routes.rb"
      else
        config.paths.add 'config/routes', with: "#{APP_ROOT}/config/routes.rb"
      end

      def require_environment!
        initialize!
      end

      def initialize!
        FileUtils.mkdir_p(Rails.root.join('db').to_s)
        super unless @initialized
      end
    end
  end
end
