module Clearance
  class Configuration
    attr_accessor \
      :cookie_expiration,
      :httponly,
      :mailer_sender,
      :password_strategy,
      :redirect_url,
      :secure_cookie,
      :user_model

    def initialize
      @cookie_expiration = lambda { 1.year.from_now.utc }
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @secure_cookie = false
      @redirect_url = '/'
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
