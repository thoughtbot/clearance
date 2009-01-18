module Clearance
  module App
    module Controllers
      module PasswordsController

        def self.included(controller)
          controller.class_eval do
            before_filter :existing_user?, :only => [:edit, :update]
            filter_parameter_logging :password, :password_confirmation
            
            def new
            end

            def create
              user = User.find_by_email(params[:password][:email])
              if user.nil?
                flash.now[:notice] = 'Unknown email'
                render :action => :new
              else
                ClearanceMailer.deliver_change_password user
                flash[:notice] = "Details for changing your password " <<
                                 "have been sent to #{user.email}"
                redirect_to url_after_create
              end
            end

            def edit
              @user = User.find_by_email_and_crypted_password(params[:email],
                                                              params[:password])
            end

            def update
              @user = User.find_by_email_and_crypted_password(params[:email],
                                                              params[:password])
              if @user.update_attributes params[:user]
                log_user_in(@user)
                redirect_to url_after_update
              else
                render :action => :edit
              end
            end
            
            private
            
            def existing_user?
              user = User.find_by_email_and_crypted_password(params[:email],
                                                             params[:password])
              if user.nil?
                render :nothing => true, :status => :not_found
              end
            end

            def url_after_create
              new_session_url
            end
            
            def url_after_update
              @user
            end
            
          end
        end
      end
    end
  end
end
