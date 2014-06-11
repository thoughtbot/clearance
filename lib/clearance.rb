require "monban"
require "clearance/back_door"
require "clearance/configuration"
require "clearance/engine"
require "clearance/version"

module Clearance
  def self.config
    @config ||= Configuration.new
  end

  def self.config=(config)
    @config = config
  end
end
