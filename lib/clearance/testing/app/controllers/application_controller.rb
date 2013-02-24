class ApplicationController < ActionController::Base
  include Clearance::Controller

  def show
    render :text => '', :layout => 'application'
  end
end
