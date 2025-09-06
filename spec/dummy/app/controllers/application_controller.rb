class ApplicationController < ActionController::Base
  include Clearance::Controller

  def show
    render inline: "Hello user #<%= current_user.id %> #{params.to_json}", layout: false
  end
end
