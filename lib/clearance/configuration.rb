module Clearance
  class Configuration
    # Controls whether the sign up route is enabled.
    # Defaults to `true`. Set to `false` to disable user creation routes.
    # The setting is ignored if routes are disabled.
    # @param [Boolean] value
    # @return [Boolean]
    attr_writer :allow_sign_up

    # The domain to use for the clearance remember token cookie.
    # Defaults to `nil`, which causes the cookie domain to default to the
    # domain of the request. For more, see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.3).
    # @return [String]
    attr_accessor :cookie_domain

    # A lambda called to set the remember token cookie expires attribute.
    # The lambda accepts the collection of cookies as an argument which
    # allows for changing the expiration according to those cookies.
    # This could be used, for example, to set a session cookie unless
    # a `remember_me` cookie was also present. By default, cookie expiration
    # is one year. For more on cookie expiration see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.1).
    # @return [Lambda]
    attr_accessor :cookie_expiration

    # The name of Clearance's remember token cookie.
    # Defaults to `remember_token`.
    # @return [String]
    attr_accessor :cookie_name

    # Controls which paths the remember token cookie is valid for.
    # Defaults to `"/"` for the entire domain. For more, see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.1.4).
    # @return [String]
    attr_accessor :cookie_path

    # Controls whether the  HttpOnly flag should be set on the remember token
    # cookie. Defaults to `false`. If `true`, the cookie will not be made
    # available to JavaScript. For more see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.6).
    # @return [Boolean]
    attr_accessor :httponly

    # Controls the address the password reset email is sent from.
    # Defaults to reply@example.com.
    # @return [String]
    attr_accessor :mailer_sender

    # The password strategy to use when authenticating and setting passwords.
    # Defaults to `Clearance::PasswordStrategies::BCrypt`.
    # @return [Class #authenticated? #password=]
    attr_accessor :password_strategy

    # The default path Clearance will redirect signed in users to.
    # Defaults to `"/"`. This can often be overridden for specific scenarios by
    # overriding controller methods that rely on it.
    # @return [String]
    attr_accessor :redirect_url

    # Set to `false` to disable Clearance's built-in routes.
    # Defaults to `true`. When set to false, your app is responsible for all
    # routes. You can dump a copy of Clearance's default routes with
    # `rails generate clearance:routes`.
    # @return [Boolean]
    attr_writer :routes

    # Controls the secure setting on the remember token cookie.
    # Defaults to `false`. When set, the browser will only send the
    # cookie to the server over HTTPS. You should set this value to true in
    # live environments to prevent session hijacking. For more, see
    # [RFC6265](http://tools.ietf.org/html/rfc6265#section-5.2.5).
    # @return [Boolean]
    attr_accessor :secure_cookie

    # The array of sign in guards to run when signing a user in.
    # Defaults to an empty array. Sign in guards respond to `call` and are
    # initialized with a session and the current stack. Each guard can decide
    # to fail the sign in, yield to the next guard, or allow the sign in.
    # @return [Array<#call>]
    attr_accessor :sign_in_guards

    # The ActiveRecord class that represents users in your application.
    # Defualts to `::User`.
    # @return [ActiveRecord::Base]
    attr_accessor :user_model

    def initialize
      @allow_sign_up = true
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_domain = nil
      @cookie_path = '/'
      @cookie_name = "remember_token"
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
      @routes = true
      @secure_cookie = false
      @sign_in_guards = []
    end

    def user_model
      @user_model ||= ::User
    end

    # Is the user sign up route enabled?
    # @return [Boolean]
    def allow_sign_up?
      @allow_sign_up
    end

    # Specifies which controller actions are allowed for user resources.
    # This will be `[:create]` is `allow_sign_up` is true (the default), and
    # empty otherwise.
    # @return [Array<Symbol>]
    def  user_actions
      if allow_sign_up?
        [:create]
      else
        []
      end
    end

    # The name of foreign key parameter for the configured user model.
    # This is derived from the `model_name` of the `user_model` setting.
    # In the default configuration, this is `user_id`.
    # @return [Symbol]
    def user_id_parameter
      "#{user_model.model_name.singular}_id".to_sym
    end

    # @return [Boolean] are Clearance's built-in routes enabled?
    def routes_enabled?
      @routes
    end

    # Reloads the clearance user model class.
    # This is called from the Clearance engine to reload the configured
    # user class during each request while in development mode, but only once
    # in production.
    # @private
    def reload_user_model
      if @user_model.present?
        @user_model = @user_model.to_s.constantize
      end
    end
  end

  # @return [Clearance::Configuration] Clearance's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set Clearance's configuration
  # @param config [Clearance::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify Clearance's current configuration
  # @yieldparam [Clearance::Configuration] config current Clearance config
  # ```
  # Clearance.configure do |config|
  #   config.routes = false
  # end
  # ```
  def self.configure
    yield configuration
  end
end
