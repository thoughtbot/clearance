class ApplicationController < ActionController::Base
  include Clearance::Authentication

  def show
    render :text => '', :layout => 'application'
  end
end
