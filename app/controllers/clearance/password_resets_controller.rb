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

  private

  def new_password_reset
    password_reset_class.new
  end

  def find_user_for_create
    user_class.find_by(params_for_create)
  end

  def params_for_create
    params.require(password_reset_class.model_name.element)
      .permit(user_lookup_field)
  end

  def create_password_reset(user)
    password_reset_class.create(
      user_class.model_name.element => user
    )
  end

  def deliver_email(password_reset)
    Clearance.config.password_reset_delivery.call(password_reset)
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
end
