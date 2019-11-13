module Clearance
  # Top-level base class that all Clearance controllers inherit from.
  # Inherits from `ApplicationController` by default and can be overridden by
  # setting a new value with {Configuration#parent_controller=}.
  # @!parse
  #   class BaseController < ApplicationController; end
  class BaseController < Clearance.configuration.parent_controller
  end
end
