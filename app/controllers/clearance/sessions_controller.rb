class Clearance::SessionsController < ApplicationController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  protect_from_forgery :except => :create

  def new
    render :template => 'sessions/new'
  end

  def create
    @user = ::User.authenticate(params[:session][:email],
                                params[:session][:password])
    if @user.nil?
      flash_failure_after_create
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      flash_success_after_create
      redirect_back_or(url_after_create)
    end
  end

  def destroy
    sign_out
    flash_success_after_destroy
    redirect_to(url_after_destroy)
  end

  private

  def flash_failure_after_create
    flash.now[:failure] = translate(:bad_email_or_password,
      :scope   => [:clearance, :controllers, :sessions],
      :default => "Bad email or password.")
  end

  def flash_success_after_create
    flash[:success] = translate(:signed_in, :default =>  "Signed in.")
  end

  def url_after_create
    '/'
  end

  def flash_success_after_destroy
    flash[:success] = translate(:signed_out, :default =>  "Signed out.")
  end

  def url_after_destroy
    sign_in_url
  end
end
