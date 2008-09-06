class ApplicationController < ActionController::Base
  include Clearance::ApplicationController
  filter_parameter_logging :password
end
