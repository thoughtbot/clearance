module Clearance
  class Configuration
    attr_accessor :mailer_sender

    def initialize
      @mailer_sender = 'donotreply@example.com'
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
  #     config.mailer_sender = 'donotreply@example.com'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
