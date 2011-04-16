class Clearance::PasswordsController < ApplicationController
  unloadable

  skip_before_filter :authenticate,        :only => [:new, :create, :edit, :update]
  before_filter :forbid_missing_token,     :only => [:edit, :update]
  before_filter :forbid_non_existent_user, :only => [:edit, :update]

  def new
    render :template => 'passwords/new'
  end

  def create
    if user = ::User.find_by_email(params[:password][:email])
      user.forgot_password!
      ::ClearanceMailer.change_password(user).deliver
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      flash_failure_after_create
      render :template => 'passwords/new'
    end
  end

  def edit
    @user = ::User.find_by_id_and_confirmation_token(
                   params[:user_id], params[:token])
    render :template => 'passwords/edit'
  end

  def update
    @user = ::User.find_by_id_and_confirmation_token(
                   params[:user_id], params[:token])

    if @user.update_password(params[:user][:password])
      sign_in(@user)
      flash_success_after_update
      redirect_to(url_after_update)
    else
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
    unless ::User.find_by_id_and_confirmation_token(
                  params[:user_id], params[:token])
      flash_failure_when_forbidden
      render :template => 'passwords/new'
    end
  end

  def flash_failure_when_forbidden
    flash.now[:failure] = translate(:forbidden,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Please double check the URL or try submitting the form again.")
  end

  def flash_notice_after_create
    flash[:notice] = translate(:deliver_change_password,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "You will receive an email within the next few minutes. " <<
                  "It contains instructions for changing your password.")
  end

  def flash_failure_after_create
    flash.now[:failure] = translate(:unknown_email,
      :scope   => [:clearance, :controllers, :passwords],
      :default => "Unknown email.")
  end

  def flash_success_after_update
    flash[:success] = translate(:signed_in, :default => "Signed in.")
  end

  def url_after_create
    sign_in_url
  end

  def url_after_update
    '/'
  end
end
