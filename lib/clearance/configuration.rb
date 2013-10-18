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
      @secure_cookie = false
      @sign_in_guards = []
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
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end
end
