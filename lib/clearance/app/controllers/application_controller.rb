module Clearance
  module App
    module Controllers
      module ApplicationController
    
        def self.included(base)
          base.class_eval do
            helper_method :current_user
            helper_method :logged_in?
        
            include InstanceMethods

         protected
            include ProtectedInstanceMethods
          end
        end
    
        module InstanceMethods
          def current_user
            user_from_session || user_from_cookie
          end
      
          def logged_in?
            ! current_user.nil?
          end
        end

        module ProtectedInstanceMethods
          def authenticate
            deny_access unless logged_in?
          end

          def user_from_session
            User.find_by_id session[:user_id]
          end

          def user_from_cookie
            if cookies[:auth_token]
              user = User.find_by_remember_token(cookies[:auth_token])
            end
            user && user.remember_token? ? user : nil
          end

          # Level of indirection so you can easily override this method
          # but also call #login .
          def log_user_in(user)
            login(user)
          end

          def login(user)
            session[:user_id] = user.id if user
          end

          def redirect_back_or(default)
            session[:return_to] ||= params[:return_to]
            session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
            session[:return_to] = nil
          end
      
          def redirect_to_root
            redirect_to root_url
          end

          def store_location
            session[:return_to] = request.request_uri
          end

          def deny_access(flash_message = nil, opts = {})
            opts[:redirect] ||= new_session_path
            store_location
            flash[:error] = flash_message if flash_message
            redirect_to opts[:redirect]
          end
        end
      end
    end
  end
end
