module Clearance
  module App
    module Controllers
      module PasswordsController

        def self.included(controller)
          controller.send(:include, Actions)
          controller.send(:include, PrivateMethods)
          
          controller.class_eval do  
            before_filter :existing_user?, :only => [:edit, :update]
            filter_parameter_logging :password, :password_confirmation
          end
        end
        
        module Actions
          def new
          end

          def create
            user = User.find_by_email(params[:password][:email])
            if user.nil?
              flash.now[:notice] = "Unknown email"
              render :action => :new
            else
              user.forgot_password!
              ClearanceMailer.deliver_change_password user
              flash[:notice] = "Details for changing your password " <<
                               "have been sent to #{user.email}"
              redirect_to url_after_create
            end
          end

          def edit
          end

          def update
            if @user.update_password(params[:user])
              sign_user_in(@user)
              redirect_to url_after_update
            else
              render :action => :edit
            end
          end
        end
        
        module PrivateMethods  
          private
          
          def existing_user?
            @user = User.find_by_id_and_token(params[:user_id], params[:token])
            if @user.nil?
              render :nothing => true, :status => :not_found
            end
          end

          def url_after_create
            new_session_url
          end
          
          def url_after_update
            root_url
          end
        end
        
      end
    end
  end
end
