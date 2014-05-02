module Clearance
  class Configuration
    attr_writer :routes

    attr_accessor \
      :cookie_domain,
      :cookie_expiration,
      :cookie_path,
      :httponly,
      :mailer_sender,
      :password_strategy,
      :redirect_url,
      :secure_cookie,
      :sign_in_guards,
      :user_model

    def initialize
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_path = '/'
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
      @routes = true
      @secure_cookie = false
      @sign_in_guards = []
    end

    def user_model
      @user_model || ::User
    end

    def user_id_parameter
      "#{user_model.model_name.singular}_id".to_sym
    end

    def routes_enabled?
      @routes
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
