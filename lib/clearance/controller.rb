module Clearance
  module Controller
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?, :signed_out?
      hide_action :authorize, :current_user, :current_user=, :deny_access,
        :sign_in, :sign_out, :signed_in?, :signed_out?
    end

    def authenticate(params)
      Clearance.configuration.user_model.authenticate(
        params[:session][:email], params[:session][:password]
      )
    end

    def authorize
      unless signed_in?
        deny_access
      end
    end

    def current_user
      clearance_session.current_user
    end

    def current_user=(user)
      clearance_session.sign_in user
    end

    def deny_access(flash_message = nil)
      store_location

      if flash_message
        flash[:notice] = flash_message
      end

      if signed_in?
        redirect_to url_after_denied_access_when_signed_in
      else
        redirect_to url_after_denied_access_when_signed_out
      end
    end

    def sign_in(user)
      clearance_session.sign_in user
    end

    def sign_out
      clearance_session.sign_out
    end

    def signed_in?
      clearance_session.signed_in?
    end

    def signed_out?
      !signed_in?
    end

    # CSRF protection in Rails >= 3.0.4
    # http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails
    def handle_unverified_request
      super
      sign_out
    end

    protected

    def clear_return_to
      session[:return_to] = nil
    end

    def clearance_session
      request.env[:clearance]
    end

    def store_location
      if request.get?
        session[:return_to] = request.fullpath
      end
    end

    def redirect_back_or(default)
      redirect_to(return_to || default)
      clear_return_to
    end

    def redirect_to_root
      redirect_to('/')
    end

    def return_to
      session[:return_to] || params[:return_to]
    end

    def url_after_denied_access_when_signed_in
      '/'
    end

    def url_after_denied_access_when_signed_out
      sign_in_url
    end
  end
end
