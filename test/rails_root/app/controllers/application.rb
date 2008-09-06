class ApplicationController < ActionController::Base
  include Clearace::ApplicationController
  filter_parameter_logging :password
end
