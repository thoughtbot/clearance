module Clearance
  module Authentication

    def self.included(controller) # :nodoc:
      controller.send(:include, InstanceMethods)

      controller.class_eval do
        helper_method :current_user, :signed_in?, :signed_out?
        hide_action   :current_user, :signed_in?, :signed_out?
      end
    end

    module InstanceMethods
      # User in the current session or remember me cookie
      #
      # @return [User, nil]
      def current_user
        @_current_user ||= (user_from_cookie || user_from_session)
      end

      # Is the current user signed in?
      #
      # @return [true, false]
      def signed_in?
        ! current_user.nil?
      end

      # Is the current user signed out?
      #
      # @return [true, false]
      def signed_out?
        current_user.nil?
      end

      # Deny the user access if they are signed out.
      #
      # @example
      #   before_filter :authenticate
      def authenticate
        deny_access unless signed_in?
      end

      # Sign user in to session.
      #
      # @param [User]
      #
      # @example
      #   sign_in(@user)
      def sign_in(user)
        if user
          session[:user_id] = user.id
        end
      end

      # Remember user with cookie.
      #
      # @param [User]
      #
      # @example
      #   remember(@user)
      def remember(user)
        user.remember_me!
        cookies[:remember_token] = { :value   => user.token,
                                     :expires => user.token_expires_at }
      end

      # Forget user. Should only be used if developer overrides sign out.
      #
      # @param [User]
      #
      # @example
      #   forget(@user)
      def forget(user)
        user.forget_me! if user
        cookies.delete(:remember_token)
        reset_session
      end

      # Store the current location.
      # Display a flash message if included.
      # Redirect to sign in.
      #
      # @param [String] optional flash message to display to denied user
      def deny_access(flash_message = nil)
        store_location
        flash[:failure] = flash_message if flash_message
        redirect_to(new_session_url)
      end

      protected

      def user_from_session
        if session[:user_id]
          return nil  unless user = ::User.find_by_id(session[:user_id])
          return user if     user.email_confirmed?
        end
      end

      def user_from_cookie
        if token = cookies[:remember_token]
          return nil  unless user = ::User.find_by_token(token)
          return user if     user.remember?
        end
      end

      def sign_user_in(user)
        warn "[DEPRECATION] sign_user_in: unnecessary. use sign_in(user) instead."
        sign_in(user)
      end

      def remember?
        params[:session] && params[:session][:remember_me] == "1"
      end

      def store_location
        session[:return_to] = request.request_uri if request.get?
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
        redirect_to(root_url)
      end
    end

  end
end
