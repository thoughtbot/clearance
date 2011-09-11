module Clearance
  class Configuration
    attr_accessor :mailer_sender, :cookie_expiration, :password_strategy

    def initialize
      @mailer_sender     = 'donotreply@example.com'
      @cookie_expiration = lambda { 1.year.from_now.utc }
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
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
