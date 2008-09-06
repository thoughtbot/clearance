module Clearance
  module ApplicationController
    
    def included(base)
      base.class_eval do
        attr_accessor :current_user
        helper_method :current_user

        before_filter :authenticate
      protected
        include ProtectedInstanceMethods
      end
    end

    module ProtectedInstanceMethods
      def authenticate
        deny_access if current_user.nil?
      end

      def current_user
        @current_user ||= (user_from_session || user_from_cookie)
      end

      def user_from_session
        User.find_by_id(session[:user_id])
      end

      def user_from_cookie
        user = User.find_by_remember_token(cookies[:auth_token]) if cookies[:auth_token]
        user && user.remember_token? ? user : nil
      end

      def login(user)
        create_session_for user
        @current_user = user
      end

      def create_session_for(user)
        session[:user_id] = user.id if user
      end

      def redirect_back_or(default)
        session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
        session[:return_to] = nil
      end

      def store_location
        session[:return_to] = request.request_uri
      end

      def deny_access(flash_message = nil, opts = {})
        opts[:redirect] ||= login_url
        store_location
        flash[:error] = flash_message if flash_message
        redirect_to opts[:redirect]
      end
    end
  end
end
