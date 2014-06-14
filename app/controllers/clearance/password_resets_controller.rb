class Clearance::PasswordResetsController < ApplicationController
  def new
    @password_reset = new_password_reset
  end

  def create
    user = find_user_for_create

    if user
      password_reset = create_password_reset(user)
      deliver_email(password_reset)
    end
  end

  def edit
    @password_reset = find_password_reset_for_update
  end

  def update
    @password_reset = find_password_reset_for_update
    reset_password(@password_reset.user, password_param)

    if complete(@password_reset)
      sign_in @password_reset.user
      redirect_to Clearance.config.url_after_sign_in
    else
      render :edit
    end
  end

  private

  def new_password_reset
    password_reset_class.new
  end

  def find_user_for_create
    user_class.find_by(params_for_create)
  end

  def params_for_create
    params.require(password_reset_class.model_name.param_key)
      .permit(user_lookup_field)
  end

  def create_password_reset(user)
    password_reset_class.create(
      user_param_key => user
    )
  end

  def deliver_email(password_reset)
    Clearance.config.password_reset_delivery.call(password_reset)
  end

  def find_password_reset_for_update
    password_reset_class.find_by!(
      token: params[:id],
      user_foreign_key => params[user_foreign_key]
    )
  end

  def complete(password_reset)
    password_reset_class.transaction do
      password_reset.user.save!
      password_reset_class.delete_for(password_reset.user)
    end
  end

  def password_param
    params[:password_reset][:password]
  end

  def password_reset_class
    Clearance.config.password_reset_class
  end

  def user_class
    Clearance.config.user_class
  end

  def user_lookup_field
    Clearance.config.user_lookup_field
  end

  def user_param_key
    Clearance.config.user_param_key
  end

  def user_foreign_key
    password_reset_class
      .reflections[user_param_key]
      .foreign_key
      .to_sym
  end
end
