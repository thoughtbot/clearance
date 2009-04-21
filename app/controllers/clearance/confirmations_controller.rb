class Clearance::ConfirmationsController < ApplicationController
  unloadable

  before_filter :forbid_confirmed_user,    :only => :new
  before_filter :forbid_missing_token,     :only => :new
  before_filter :forbid_non_existent_user, :only => :new
  filter_parameter_logging :token

  def new
    create
  end

  def create
    @user = ::User.find_by_id_and_token(params[:user_id], params[:token])
    @user.confirm_email!

    sign_user_in(@user)
    flash[:success] = "Confirmed email and signed in."
    redirect_to url_after_create
  end

  private

  def forbid_confirmed_user
    user = ::User.find_by_id(params[:user_id])
    if user && user.email_confirmed?
      raise ActionController::Forbidden, "confirmed user"
    end
  end

  def forbid_missing_token
    if params[:token].blank?
      raise ActionController::Forbidden, "missing token"
    end
  end

  def forbid_non_existent_user
    unless ::User.find_by_id_and_token(params[:user_id], params[:token])
      raise ActionController::Forbidden, "non-existent user"
    end
  end

  def url_after_create
    root_url
  end

end
