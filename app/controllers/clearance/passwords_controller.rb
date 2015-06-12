require 'active_support/deprecation'

class Clearance::PasswordsController < Clearance::BaseController
  skip_before_filter :require_login, only: [:create, :edit, :new, :update]
  skip_before_filter :authorize, only: [:create, :edit, :new, :update]
  before_filter :ensure_existing_user, only: [:edit, :update]

  def create
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end
    render template: 'passwords/create'
  end

  def edit
    @user = find_user_for_edit
    render template: 'passwords/edit'
  end

  def new
    render template: 'passwords/new'
  end

  def update
    @user = find_user_for_update

    if @user.update_password password_reset_params
      sign_in @user
      redirect_to url_after_update
    else
      flash_failure_after_update
      render template: 'passwords/edit'
    end
  end

  private

  def deliver_email(user)
    mail = ::ClearanceMailer.change_password(user)

    if Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new("4.2.0")
      mail.deliver_later
    else
      mail.deliver
    end
  end

  def password_reset_params
    if params.has_key? :user
      ActiveSupport::Deprecation.warn %{Since locales functionality was added, accessing params[:user] is no longer supported.}
      params[:user][:password]
    else
      params[:password_reset][:password]
    end
  end

  def find_user_by_id_and_confirmation_token
    user_param = Clearance.configuration.user_id_parameter

    Clearance.configuration.user_model.
      find_by_id_and_confirmation_token params[user_param], params[:token].to_s
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
    flash.now[:notice] = translate(:forbidden,
      scope: [:clearance, :controllers, :passwords],
      default: t('flashes.failure_when_forbidden'))
  end

  def flash_failure_after_update
    flash.now[:notice] = translate(:blank_password,
      scope: [:clearance, :controllers, :passwords],
      default: t('flashes.failure_after_update'))
  end

  def url_after_create
    sign_in_url
  end

  def url_after_update
    Clearance.configuration.redirect_url
  end
end
