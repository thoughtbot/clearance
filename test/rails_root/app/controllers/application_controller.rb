class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include Clearance::Authentication
end
