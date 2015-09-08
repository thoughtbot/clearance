require 'active_support/deprecation'

class Clearance::PasswordsController < Clearance::BaseController
  skip_before_filter :require_login, only: [:create, :edit, :new, :update]
  skip_before_filter :authorize, only: [:create, :edit, :new, :update]
  before_filter :ensure_valid_password_reset, only: [:edit, :update]

  def create
    if user = find_user_for_create
      password_reset = PasswordReset.create!(user: user)
      deliver_email(password_reset)
    end
    render template: 'passwords/create'
  end

  def edit
    @password_reset = find_active_password_reset
    render template: 'passwords/edit'
  end

  def new
    render template: 'passwords/new'
  end

  def update
    @password_reset = find_active_password_reset

    if @password_reset.complete(password_reset_params)
      sign_in @password_reset.user
      redirect_to url_after_update
    else
      flash_failure_after_update
      render template: 'passwords/edit'
    end
  end

  private

  def deliver_email(password_reset)
    mail = ::ClearanceMailer.change_password(password_reset)

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

  def find_active_password_reset
    @find_active_password_reset ||= PasswordReset.
      active_for(params[user_param]).
      find_by_token(params[:token])
  end

  def user_param
    Clearance.configuration.user_id_parameter
  end

  def find_user_for_create
    Clearance.configuration.user_model.
      find_by_normalized_email params[:password][:email]
  end

  def ensure_valid_password_reset
    unless find_active_password_reset
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
