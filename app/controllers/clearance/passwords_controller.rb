class Clearance::PasswordsController < ApplicationController
  unloadable

  skip_before_filter :authorize,           :only => [:new, :create, :edit, :update]
  before_filter :forbid_missing_token,     :only => [:edit, :update]
  before_filter :forbid_non_existent_user, :only => [:edit, :update]

  def new
    render :template => 'passwords/new'
  end

  def create
    if user = Clearance.configuration.user_model.find_by_email(
                   params[:password][:email])
      user.forgot_password!
      ::ClearanceMailer.change_password(user).deliver
      render :template => 'passwords/create'
    else
      flash_failure_after_create
      render :template => 'passwords/new'
    end
  end

  def edit
    @user = Clearance.configuration.user_model.find_by_id_and_confirmation_token(
                   params[:user_id], params[:token])
    render :template => 'passwords/edit'
  end

  def update
    @user = Clearance.configuration.user_model.find_by_id_and_confirmation_token(
                   params[:user_id], params[:token])

    if @user.update_password(params[:user][:password])
      sign_in(@user)
      redirect_to(url_after_update)
    else
      flash_failure_after_update
      render :template => 'passwords/edit'
    end
  end

  private

  def forbid_missing_token
    if params[:token].blank?
      flash_failure_when_forbidden
      render :template => 'passwords/new'
    end
  end

  def forbid_non_existent_user
    unless Clearance.configuration.user_model.find_by_id_and_confirmation_token(
                  params[:user_id], params[:token])
      flash_failure_when_forbidden
      render :template => 'passwords/new'
    end
  end

  def flash_failure_when_forbidden
    flash.now[:notice] = translate(:forbidden,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Please double check the URL or try submitting the form again.")
  end

  def flash_failure_after_create
    flash.now[:notice] = translate(:unknown_email,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Unknown email.")
  end

  def flash_failure_after_update
    flash.now[:notice] = translate(:blank_password,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Password can't be blank.")
  end

  def url_after_create
    sign_in_url
  end

  def url_after_update
    '/'
  end
end
