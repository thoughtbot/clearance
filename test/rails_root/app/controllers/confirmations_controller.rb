class ConfirmationsController < ApplicationController
  
  before_filter :existing_user?, :only => [:new, :create]
  
  def new
    @user = User.find_by_id_and_salt(params[:user_id], params[:salt])
  end

  def create
    @user = User.find_by_id_and_salt(params[:user_id], params[:salt])
    @user.confirm!
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

 private

  def existing_user?
    user = User.find_by_id_and_salt(params[:user_id], params[:salt])
    if user.nil?
      render :nothing => true, :status => :not_found
    end
  end
  
end
