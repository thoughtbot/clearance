class ApplicationController < ActionController::Base
  include Clearance::Controller

  def show
    render inline: "Hello user #<%= current_user.id %>", layout: false
  end
end
