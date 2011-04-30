class Clearance::UsersController < ApplicationController
  unloadable

  skip_before_filter :authorize,    :only => [:new, :create]
  before_filter :redirect_to_root,  :only => [:new, :create], :if => :signed_in?

  def new
    @user = ::User.new(params[:user])
    render :template => 'users/new'
  end

  def create
    @user = ::User.new(params[:user])
    if @user.save
      flash_notice_after_create
      sign_in(@user)
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end

  private

  def flash_notice_after_create
    flash[:notice] = translate(:signed_up,
      :scope   => [:clearance, :controllers, :users],
      :default => "You are now signed up.")
  end

  def url_after_create
    '/'
  end
end
