class Clearance::SessionsController < ApplicationController
  unloadable

  skip_before_filter :authorize, :only => [:new, :create, :destroy]
  protect_from_forgery :except => :create

  def new
    render :template => 'sessions/new'
  end

  def create
    @user = authenticate(params)
    if @user.nil?
      flash_failure_after_create
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      redirect_back_or(url_after_create)
    end
  end

  def destroy
    sign_out
    redirect_to(url_after_destroy)
  end

  private

  def flash_failure_after_create
    flash.now[:notice] = translate(:bad_email_or_password,
      :scope   => [:clearance, :controllers, :sessions],
      :default => "Bad email or password.")
  end

  def url_after_create
    '/'
  end

  def url_after_destroy
    sign_in_url
  end
end
