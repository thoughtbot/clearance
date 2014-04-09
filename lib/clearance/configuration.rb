module Clearance
  class Configuration
    attr_writer :allow_sign_up

    attr_accessor \
      :cookie_domain,
      :cookie_expiration,
      :cookie_path,
      :httponly,
      :mailer_sender,
      :password_strategy,
      :passwords_controller,
      :redirect_url,
      :secure_cookie,
      :sessions_controller,
      :sign_in_guards,
      :user_model,
      :users_controller

    def initialize
      @allow_sign_up = true
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_path = '/'
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @passwords_controller = 'clearance/passwords'
      @redirect_url = '/'
      @secure_cookie = false
      @sessions_controller = 'clearance/sessions'
      @sign_in_guards = []
      @users_controller = 'clearance/users'
    end

    def user_model
      @user_model || ::User
    end

    def allow_sign_up?
      @allow_sign_up
    end

    def  user_actions
      if allow_sign_up?
        [:create]
      else
        []
      end
    end

    def user_id_parameter
      "#{user_model.model_name.singular}_id".to_sym
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
