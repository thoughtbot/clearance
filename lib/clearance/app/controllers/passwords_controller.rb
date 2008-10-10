module Clearance
  module PasswordsController

    def self.included(base)
      base.class_eval do
        before_filter :existing_user?, :only => [:edit, :update]
        filter_parameter_logging :password, :password_confirmation
        include InstanceMethods
      private
        include PrivateInstanceMethods
      end
    end

    module InstanceMethods
      def new
      end

      def create
        user = User.find_by_email params[:password][:email]
        if user.nil?
          flash.now[:warning] = 'Unknown email'
          render :action => :new
        else
          Mailer.deliver_change_password user
          redirect_to login_path
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
          session[:user_id] = @user.id
          redirect_to @user
        else
          render :action => :edit
        end
      end
    end

    module PrivateInstanceMethods
      def existing_user?
        user = User.find_by_email_and_crypted_password(params[:email],
                                                       params[:password])
        if user.nil?
          render :nothing => true, :status => :not_found
        end
      end
    end

  end
end
