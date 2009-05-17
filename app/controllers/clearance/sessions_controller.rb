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
      flash.now[:failure] = translate(:bad_email_or_password,
        :scope   => [:clearance, :controllers, :sessions],
        :default => "Bad email or password.")
      render :template => 'sessions/new', :status => :unauthorized
    else
      if @user.email_confirmed?
        sign_user_in(@user)
        remember(@user) if remember?
        flash[:success] = translate(:signed_in, :default =>  "Signed in.")
        redirect_back_or url_after_create
      else
        ::ClearanceMailer.deliver_confirmation(@user)
        deny_access(translate(:unconfirmed_email,
          :scope   => [:clearance, :controllers, :sessions],
          :default => "User has not confirmed email. " <<
                      "Confirmation email will be resent."))
      end
    end
  end

  def destroy
    forget(current_user)
    flash[:success] = translate(:signed_out, :default =>  "Signed out.")
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
