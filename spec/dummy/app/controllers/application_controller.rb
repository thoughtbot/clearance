class ApplicationController < ActionController::Base
  include Clearance::Controller

  def show
    if Rails::VERSION::MAJOR >= 5
      render html: "", layout: "application"
    else
      render text: "", layout: "application"
    end
  end

  def static_endpoint
    if params[:use_current_user]
      current_user # Just trigger the authentication
    end

    head :ok
  end
end
