class ApplicationController < ActionController::Base
  include Clearance::Controller

  def show
    render html: "", layout: "application"
  end

  def static_endpoint
    if params[:use_current_user]
      current_user # Just trigger the authentication
    end

    head :ok
  end
end
