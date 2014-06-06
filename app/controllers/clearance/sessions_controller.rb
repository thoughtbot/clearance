class Clearance::SessionsController < ApplicationController
  def new
  end

  def create
    user = authenticate_session(session_params)

    if sign_in(user)
      redirect_to url_after_sign_in
    else
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(*permitted_session_params)
  end

  def permitted_session_params
    [Clearance.config.user_lookup_field, Clearance.config.user_token_field]
  end

  def url_after_sign_in
    Clearance.config.url_after_sign_in
  end
end
