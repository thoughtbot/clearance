module Clearance
  class Configuration
    attr_accessor :mailer_sender, :cookie_expiration, :password_strategy, :user_model_name

    def initialize
      @mailer_sender     = 'donotreply@example.com'
      @cookie_expiration = lambda { 1.year.from_now.utc }
      @user_model_name   = '::User'
    end

    def user_model_name=(model_name)
      @user_model_name = model_name
      @user_model      = nil
    end

    def user_model
      @user_model ||= @user_model_name.constantize
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Configure Clearance someplace sensible,
  # like config/initializers/clearance.rb
  #
  # If you want users to only be signed in during the current session
  # instead of being remembered, do this:
  #
  #   config.cookie_expiration = lambda { }
  #
  # @example
  #   Clearance.configure do |config|
  #     config.mailer_sender     = 'me@example.com'
  #     config.cookie_expiration = lambda { 2.weeks.from_now.utc }
  #     config.password_strategy = MyPasswordStrategy
  #     config.user_model_name   = 'MyNamespace::MyUser'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
