require 'clearance/configuration'
require 'clearance/session'
require 'clearance/rack_session'
require 'clearance/back_door'
require 'clearance/controller'
require 'clearance/user'
require 'clearance/engine'
require 'clearance/password_strategies'
require 'clearance/constraints'

module Clearance
  def self.root
    File.expand_path('../..', __FILE__)
  end
end
