module Clearance
  module App
    module Controllers
      module SessionsController

        def self.included(controller)
          controller.class_eval do
            
            protect_from_forgery :except => :create
            filter_parameter_logging :password
        
            def create
              @user = User.authenticate(params[:session][:email], 
                                        params[:session][:password])
              if @user.nil?
                sign_in_failure
              else
                if @user.email_confirmed?
                  remember(@user) if remember?
                  sign_user_in(@user)
                  sign_in_successful
                else
                  deny_access("User has not confirmed email.")
                end
              end
            end

            def destroy
              forget(current_user)
              reset_session
              flash[:notice] = "You have been signed out."
              redirect_to url_after_destroy
            end
        
            private
            
            def sign_in_successful(message = "Signed in successfully")
              flash[:notice] = message
              redirect_back_or url_after_create
            end

            def sign_in_failure(message = "Bad email or password.")
              flash.now[:notice] = message
              render :action => :new
            end

            def remember?
              params[:session] && params[:session][:remember_me] == "1"
            end
            
            def remember(user)
              user.remember_me!
              cookies[:remember_token] = { :value   => user.remember_token, 
                                           :expires => user.remember_token_expires_at }
            end

            def forget(user)
              user.forget_me! if user
              cookies.delete :remember_token
            end

            def url_after_create
              root_url
            end

            def url_after_destroy
              new_session_url
            end
            
          end
        end
          
      end
    end
  end
end
