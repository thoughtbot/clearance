require 'active_support/deprecation'

class Clearance::PasswordsController < Clearance::BaseController
  before_action :ensure_existing_user, only: [:edit, :update]
  skip_before_action :require_login, only: [:create, :edit, :new, :update], raise: false

  def new
    render template: "passwords/new"
  end

  def create
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end

    render template: "passwords/create"
  end

  def edit
    @user = find_user_for_edit

    if params[:token]
      session[:password_reset_token] = params[:token]
      redirect_to url_for
    else
      render template: "passwords/edit"
    end
  end

  def update
    @user = find_user_for_update

    if @user.update_password password_reset_params
      sign_in @user
      redirect_to url_after_update
      session[:password_reset_token] = nil
    else
      flash_failure_after_update
      render template: "passwords/edit"
    end
  end

  private

  def deliver_email(user)
    mail = ::ClearanceMailer.change_password(user)
    mail.deliver_later
  end

  def password_reset_params
    params[:password_reset][:password]
  end

  def find_user_by_id_and_confirmation_token
    user_param = Clearance.configuration.user_id_parameter
    token = params[:token] || session[:password_reset_token]

    Clearance.configuration.user_model.
      find_by_id_and_confirmation_token params[user_param], token.to_s
  end

  def find_user_for_create
    Clearance.configuration.user_model.
      find_by_normalized_email params[:password][:email]
  end

  def find_user_for_edit
    find_user_by_id_and_confirmation_token
  end

  def find_user_for_update
    find_user_by_id_and_confirmation_token
  end

  def ensure_existing_user
    unless find_user_by_id_and_confirmation_token
      flash_failure_when_forbidden
      render template: "passwords/new"
    end
  end

  def flash_failure_when_forbidden
    flash.now[:alert] = translate(:forbidden,
      scope: [:clearance, :controllers, :passwords],
      default: t("flashes.failure_when_forbidden"))
  end

  def flash_failure_after_update
    flash.now[:alert] = translate(:blank_password,
      scope: [:clearance, :controllers, :passwords],
      default: t("flashes.failure_after_update"))
  end

  def url_after_update
    Clearance.configuration.redirect_url
  end
end
