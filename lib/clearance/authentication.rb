module Clearance
  module Authentication
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?, :signed_out?
      hide_action   :current_user, :current_user=,
                    :signed_in?,   :signed_out?,
                    :sign_in,      :sign_out,
                    :authorize,    :deny_access
    end

    # Finds the user from the rack clearance session
    #
    # @return [User, nil]
    def current_user
      clearance_session.current_user
    end

    # Set the current user
    #
    # @param [User]
    def current_user=(user)
      clearance_session.sign_in user
    end

    # Is the current user signed in?
    #
    # @return [true, false]
    def signed_in?
      clearance_session.signed_in?
    end

    # Is the current user signed out?
    #
    # @return [true, false]
    def signed_out?
      !signed_in?
    end

    # Sign user in to cookie.
    #
    # @param [User]
    #
    # @example
    #   sign_in(@user)
    def sign_in(user)
      clearance_session.sign_in user
    end

    # Sign user out of cookie.
    #
    # @example
    #   sign_out
    def sign_out
      clearance_session.sign_out
    end

    # Find the user by the given params or return nil.
    # By default, uses email and password.
    # Redefine this method and User.authenticate for other mechanisms
    # such as username and password.
    #
    # @example
    #   @user = authenticate(params)
    def authenticate(params)
      Clearance.configuration.user_model.authenticate(params[:session][:email],
                                                      params[:session][:password])
    end

    # Deny the user access if they are signed out.
    #
    # @example
    #   before_filter :authorize
    def authorize
      deny_access unless signed_in?
    end

    # Store the current location and redirect to sign in.
    # Display a failure flash message if included.
    #
    # @param [String] optional flash message to display to denied user
    def deny_access(flash_message = nil)
      store_location
      flash[:notice] = flash_message if flash_message
      if signed_in?
        redirect_to(url_after_denied_access_when_signed_in)
      else
        redirect_to(url_after_denied_access_when_signed_out)
      end
    end

    # CSRF protection in Rails >= 3.0.4
    # http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails
    def handle_unverified_request
      super
      sign_out
    end

    protected

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

    def return_to
      session[:return_to] || params[:return_to]
    end

    def clear_return_to
      session[:return_to] = nil
    end

    def redirect_to_root
      redirect_to('/')
    end

    def url_after_denied_access_when_signed_in
      '/'
    end

    def url_after_denied_access_when_signed_out
      sign_in_url
    end
  end
end
