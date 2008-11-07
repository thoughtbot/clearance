class SessionMailerOverridesController < ApplicationController
  include Clearance::App::Controllers::SessionsController

  def mailer_model
    ClearanceOverrideMailer
  end
end
