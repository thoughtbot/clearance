class Clearance::SessionsController < ApplicationController
  skip_before_filter :authorize, :only => [:create, :new, :destroy]
  protect_from_forgery :except => :create

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash.now.notice = status.failure_message
        render :template => 'sessions/new', :status => :unauthorized
      end
    end
  end

  def destroy
    sign_out
    redirect_to url_after_destroy
  end

  def new
    render :template => 'sessions/new'
  end

  private

  def flash_failure_after_create
    flash.now[:notice] = translate(:bad_email_or_password,
      :scope => [:clearance, :controllers, :sessions],
      :default => t('flashes.failure_after_create', :sign_up_path => sign_up_path).html_safe)
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def url_after_destroy
    sign_in_url
  end
end
