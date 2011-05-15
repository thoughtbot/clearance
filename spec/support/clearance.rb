require 'clearance'

Clearance.configure do |config|
end

class ApplicationController < ActionController::Base
  include Clearance::Authentication
end

class User < ActiveRecord::Base
  include Clearance::User
end
