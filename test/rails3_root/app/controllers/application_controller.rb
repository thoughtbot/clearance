class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include Clearance::Authentication
  before_filter :authenticate
end
