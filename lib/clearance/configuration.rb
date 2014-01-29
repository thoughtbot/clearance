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
      :sign_in_guards

    def initialize
      @allow_sign_up = true
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_path = '/'
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
      @secure_cookie = false
      @sign_in_guards = []
      @user_model = []
    end

    def user_model=(user_model)
      @user_model = Array(user_model)
    end

    def user_model
      (@user_model.empty?) ? [::User] : @user_model
    end

    def user_model_apply
      user_model.each do |user|
        result = yield user
        return result if result
      end
      nil
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
