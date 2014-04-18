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
      :redirect_url,
      :secure_cookie,
      :sign_in_guards,
      :user_model

    def initialize
      @allow_sign_up = true
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_path = '/'
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
      @sign_in_guards = []
    end

    def user_model
      @user_model || ::User
    end

    def allow_sign_up?
      @allow_sign_up
    end

    def secure_cookie
      if @secure_cookie.nil?
        warn <<-WARNING.strip_heredoc

          Clearance.configuration.secure_cookie is not set and is defaulting to
          false. This subjects your users to session hijacking. We reccomend
          this be set to 'true' in any live environment and explicitly set to
          false in development and test if necessary.
        WARNING

        @secure_cookie = false
      end

      @secure_cookie
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
