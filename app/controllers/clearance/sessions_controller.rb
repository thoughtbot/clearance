class Clearance::SessionsController < ApplicationController
  unloadable

  protect_from_forgery :except => :create
  filter_parameter_logging :password

  def new
    render :template => 'sessions/new'
  end

  def create
    @user = ::User.authenticate(params[:session][:email],
                              params[:session][:password])
    if @user.nil?
      flash.now[:failure] = "Bad email or password."
      render :template => 'sessions/new', :status => :unauthorized
    else
      if @user.email_confirmed?
        sign_user_in(@user)
        remember(@user) if remember?
        flash[:success] = "Signed in."
        redirect_back_or url_after_create
      else
        ::ClearanceMailer.deliver_confirmation(@user)
        deny_access("User has not confirmed email. Confirmation email will be resent.")
      end
    end
  end

  def destroy
    forget(current_user)
    flash[:success] = "Signed out."
    redirect_to url_after_destroy
  end

  private

  def url_after_create
    root_url
  end

  def url_after_destroy
    new_session_url
  end
end
