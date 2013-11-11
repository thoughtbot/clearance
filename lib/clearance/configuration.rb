module Clearance
  class Configuration
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
      @secure_cookie = false
      @sign_in_guards = []
    end

    def user_model
      @user_model || ::User
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
