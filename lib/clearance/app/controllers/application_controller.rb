module Clearance
  module App
    module Controllers
      module ApplicationController
    
        def self.included(controller)
          controller.class_eval do
            
            helper_method :current_user
            helper_method :signed_in?
        
            def current_user
              user_from_session || user_from_cookie
            end

            def signed_in?
              ! current_user.nil?
            end
            
            protected
            
            def authenticate
              deny_access unless signed_in?
            end

            def user_from_session
              if session[:user_id] && session[:salt]
                user = User.find_by_id_and_salt(session[:user_id], session[:salt])
              end
              user && user.email_confirmed? ? user : nil
            end

            def user_from_cookie
              if cookies[:remember_token]
                user = User.find_by_remember_token(cookies[:remember_token])
              end
              user && user.remember? ? user : nil
            end

            # Hook
            def sign_user_in(user)
              sign_in(user)
            end

            def sign_in(user)
              if user
                session[:user_id] = user.id
                session[:salt]    = user.salt
              end
            end

            def redirect_back_or(default)
              session[:return_to] ||= params[:return_to]
              if session[:return_to] 
                redirect_to(session[:return_to])
              else 
                redirect_to(default)
              end
              session[:return_to] = nil
            end

            def redirect_to_root
              redirect_to root_url
            end

            def store_location
              session[:return_to] = request.request_uri
            end

            def deny_access(flash_message = nil, opts = {})
              store_location
              flash[:failure] = flash_message if flash_message
              render :template => "/sessions/new", :status => :unauthorized 
            end
            
          end
        end
        
      end
    end
  end
end
