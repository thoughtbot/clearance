module Clearance
  module App
    module Controllers
      module SessionsController

        def self.included(controller)
          controller.send(:include, Actions)
          controller.send(:include, PrivateMethods)

          controller.class_eval do
            protect_from_forgery :except => :create
            filter_parameter_logging :password
          end
        end

        module Actions
          def create
            @user = User.authenticate(params[:session][:email],
                                      params[:session][:password])
            if @user.nil?
              flash.now[:notice] = "Bad email or password."
              render :action => :new, :status => :unauthorized
            else
              if @user.email_confirmed?
                remember(@user) if remember?
                sign_user_in(@user)
                flash[:notice] = "Signed in successfully."
                redirect_back_or url_after_create
              else
                ClearanceMailer.deliver_confirmation(@user)
                deny_access("User has not confirmed email. Confirmation email will be resent.")
              end
            end
          end

          def destroy
            forget(current_user)
            reset_session
            flash[:notice] = "You have been signed out."
            redirect_to url_after_destroy
          end
        end

        module PrivateMethods
          private

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
