class Clearance::UsersController < ApplicationController
  unloadable

  skip_before_filter :authorize,   :only => [:new, :create]
  before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?

  def new
    @user = ::User.new(params[:user])
    render :template => 'users/new'
  end

  def create
    @user = ::User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash_success_after_create
      redirect_to(url_after_create)
    else
      flash_failure_after_create
      render :template => 'users/new'
    end
  end

  private

  def flash_success_after_create
    flash[:notice] = translate(:signed_up,
      :scope   => [:clearance, :controllers, :users],
      :default => "You are now signed up.")
  end

  def flash_failure_after_create
    flash.now[:notice] = translate(:bad_email_or_password,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Must be a valid email address. Password can't be blank.")
  end

  def url_after_create
    '/'
  end
end
