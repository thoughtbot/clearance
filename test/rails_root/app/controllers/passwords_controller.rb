class PasswordsController < ApplicationController
  
  before_filter :existing_user?, :only => [:edit, :update]

  def new
  end

  def create
    user = User.find_by_email params[:password][:email]
    if user.nil?
      flash.now[:warning] = 'Unknown email'
      render :action => :new
    else
      Mailer.deliver_change_password user
      redirect_to login_path
    end
  end

  def edit
    @user = User.find_by_id_and_crypted_password(params[:id],
                                                 params[:password])
  end

  def update
    @user = User.find_by_id_and_crypted_password(params[:id],
                                                 params[:password])
    if @user.update_attributes params[:user]
      session[:user_id] = @user.id
      redirect_to @user
    else
      render :action => :edit
    end
  end

 private

  def existing_user?
    user = User.find_by_id_and_crypted_password(params[:id],
                                                params[:password])
    if user.nil?
      render :nothing => true, :status => :not_found
    end
  end
end
