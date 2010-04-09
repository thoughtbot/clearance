module Clearance
  class Configuration
    attr_accessor :mailer_sender, :cookie_duration

    def initialize
      @mailer_sender   = 'donotreply@example.com'
      @cookie_duration = 1.year
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
  #     config.mailer_sender   = 'me@example.com'
  #     config.cookie_duration = 2.weeks
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
