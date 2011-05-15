require 'clearance'

Clearance.configure do |config|
end

class ApplicationController < ActionController::Base
  include Clearance::Authentication

  def show
    render :text => "", :layout => 'application'
  end
end

class User < ActiveRecord::Base
  include Clearance::User
end
