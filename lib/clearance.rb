require "clearance/config"
require "clearance/engine"
require "clearance/version"
require "monban"

module Clearance
  BackDoor = Monban::BackDoor

  def self.config
    @config ||= Config.new
  end

  def self.config=(config)
    @config = config
  end
end
