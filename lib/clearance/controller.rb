require 'clearance/authentication'
require 'clearance/authorization'

module Clearance
  # Adds clearance controller helpers to the controller it is mixed into.
  #
  # This exposes clearance controller and helper methods such as `current_user`.
  # See {Authentication} and {Authorization} documentation for complete
  # documentation on the methods.
  #
  # The `clearance:install` generator automatically adds this mixin to
  # `ApplicationController`, which is the recommended configuration.
  #
  #     class ApplicationController < ActionController::Base
  #       include Clearance::Controller
  #     end
  #
  module Controller
    extend ActiveSupport::Concern

    include Clearance::Authentication
    include Clearance::Authorization
  end
end
