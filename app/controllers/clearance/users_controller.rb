class Clearance::UsersController < ApplicationController
  unloadable

  before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?
  filter_parameter_logging :password

  def new
    @user = ::User.new(params[:user])
    render :template => 'users/new'
  end

  def create
    @user = ::User.new params[:user]
    if @user.save
      ::ClearanceMailer.deliver_confirmation @user
      flash[:notice] = translate(:deliver_confirmation,
        :scope   => [:clearance, :controllers, :users],
        :default => "You will receive an email within the next few minutes. " <<
                    "It contains instructions for confirming your account.")
      redirect_to url_after_create
    else
      render :template => 'users/new'
    end
  end

  private

  def url_after_create
    new_session_url
  end
end
