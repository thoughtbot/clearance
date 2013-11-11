module Clearance
  class Configuration
    attr_accessor \
      :cookie_expiration,
      :cookie_domain,
      :cookie_path,
      :secure_cookie,
      :httponly,
      :mailer_sender,
      :password_strategy,
      :redirect_url,
      :user_model,
      :sign_in_guards

    def initialize
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_path = '/'
      @secure_cookie = false
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
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
