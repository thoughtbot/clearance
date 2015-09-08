require 'clearance/configuration'
require 'clearance/sign_in_guard'
require 'clearance/session'
require 'clearance/rack_session'
require 'clearance/back_door'
require 'clearance/controller'
require 'clearance/user'
require 'clearance/engine'
require "clearance/password_resets_deactivator"
require 'clearance/password_strategies'
require 'clearance/constraints'

module Clearance
  # @deprecated Use `Gem::Specification` API if you need to access Clearance's
  #   Gem root.
  def self.root
    warn "#{Kernel.caller.first}: [DEPRECATION] `Clearance.root` is " +
      "deprecated and will be removed in the next major release. If you need " +
      "to find Clearance's root, you can use the `Gem::Specification` API."
    File.expand_path('../..', __FILE__)
  end
end
