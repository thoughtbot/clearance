module Clearance
  module Authentication

    def self.included(controller)
      controller.send(:include, InstanceMethods)

      controller.class_eval do
        helper_method :current_user, :signed_in?, :signed_out?
        hide_action   :current_user, :signed_in?, :signed_out?
      end
    end

    module InstanceMethods
      def current_user
        @_current_user ||= (user_from_cookie || user_from_session)
      end

      def signed_in?
        ! current_user.nil?
      end

      def signed_out?
        current_user.nil?
      end

      protected

      def authenticate
        deny_access unless signed_in?
      end

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

      def sign_in(user)
        if user
          session[:user_id] = user.id
        end
      end

      def remember?
        params[:session] && params[:session][:remember_me] == "1"
      end

      def remember(user)
        user.remember_me!
        cookies[:remember_token] = { :value   => user.token,
                                     :expires => user.token_expires_at }
      end

      def forget(user)
        user.forget_me! if user
        cookies.delete(:remember_token)
        reset_session
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

      def store_location
        session[:return_to] = request.request_uri if request.get?
      end

      def deny_access(flash_message = nil, opts = {})
        store_location
        flash[:failure] = flash_message if flash_message
        redirect_to(new_session_url)
      end
    end

  end
end
