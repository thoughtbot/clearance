require "clearance/configuration"
require "clearance/engine"
require "clearance/version"
require "monban"

module Clearance
  BackDoor = Monban::BackDoor

  def self.config
    @config ||= Configuration.new
  end

  def self.config=(config)
    @config = config
  end
end
