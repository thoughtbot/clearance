class Clearance::SignUpsController < ApplicationController
  def new
    @user = Monban.user_class.new
  end

  def create
    @user = user_from_params

    if @user.valid?
      sign_in(@user)
      redirect_to url_after_sign_up
    else
      render :new
    end
  end

  private

  def user_from_params
    sign_up(user_params)
  end

  def user_params
    params.require(user_param_key).permit(*permitted_user_params)
  end

  def user_param_key
    Monban.user_class.to_s.underscore.to_sym
  end

  def permitted_user_params
    [Monban.config.user_lookup_field, Monban.config.user_token_field]
  end

  def url_after_sign_up
    Clearance.config.url_after_sign_up
  end
end
