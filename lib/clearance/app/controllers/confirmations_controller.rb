module Clearance
  module App
    module Controllers
      module ConfirmationsController
    
        def self.included(controller)
          controller.send(:include, Actions)
          controller.send(:include, PrivateMethods)
          
          controller.class_eval do
            before_filter :email_confirmed_user?, :only => :new
            before_filter :existing_user?, :only => :new
            filter_parameter_logging :token    
          end
        end
        
        module Actions
          def new
            create
          end

          def create
            @user.confirm_email!
            sign_user_in(@user)
            flash[:success] = "Confirmed email and signed in."
            redirect_to url_after_create
          end
        end
        
        module PrivateMethods
          private
          
          def email_confirmed_user?
            @user = User.find_by_id(params[:user_id])
            if @user.nil?
              render :nothing => true, :status => :not_found
            elsif @user.email_confirmed?
              redirect_to new_session_url
            end
          end
          
          def existing_user?
            @user = User.find_by_id_and_token(params[:user_id], params[:token])
            if @user.nil?
              render :nothing => true, :status => :not_found
            end
          end

          def url_after_create
            root_url
          end
        end
        
      end
    end
  end
end
