module Clearance
  class Configuration
    attr_accessor \
      :cookie_expiration,
      :mailer_sender,
      :password_strategy,
      :redirect_url,
      :secure_cookie,
      :user_model,
      :layout

    def initialize
      @cookie_expiration = lambda { 1.year.from_now.utc }
      @mailer_sender = 'reply@example.com'
      @secure_cookie = false
      @redirect_url = '/'
      @layout = nil
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
