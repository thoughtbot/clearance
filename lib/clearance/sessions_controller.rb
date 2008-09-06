module Clearance
  module SessionsController

    skip_before_filter :authenticate
    protect_from_forgery :except => :create
    filter_parameter_logging :password

    def create
      remember_me = params[:session][:remember_me] if params[:session]
      login_via_password(params[:session][:email], params[:session][:password], remember_me)
    end

    def destroy
      forget current_user
      reset_session
      flash[:notice] = 'You have been logged out.'
      redirect_to login_url
    end

    protected

    def login_via_password(email, password, remember_me)
      user = User.authenticate(email, password)
      if login(user)
        remember(user) if remember_me == '1'
        login_successful
      else
        login_failure
      end
    end

    def login_successful
      flash[:notice] = 'Logged in successfully'
      redirect_back_or root_url
    end

    def login_failure(message = "Bad email or password.")
      flash.now[:notice] = message
      render :action => :new
    end

    def remember(user)
      user.remember_me!
      cookies[:auth_token] = { :value   => user.remember_token, 
                               :expires => user.remember_token_expires_at }
    end

    def forget(user)
      user.forget_me! if user
      cookies.delete :auth_token
    end

  end
end
