class ApplicationController < ActionController::Base
  include Clearance::Controller

  def show
    render html: "", layout: "application"
  end
end
