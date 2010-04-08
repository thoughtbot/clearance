module Clearance
  class Configuration
    attr_accessor :mailer_sender, :remember_token_expires_at

    def initialize
      @mailer_sender             = 'donotreply@example.com'
      @remember_token_expires_at = 1.year.from_now.utc
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Configure Clearance someplace sensible,
  # like config/initializers/clearance.rb
  #
  # @example
  #   Clearance.configure do |config|
  #     config.mailer_sender             = 'donotreply@example.com'
  #     config.remember_token_expires_at = 1.year.from_now.utc
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
