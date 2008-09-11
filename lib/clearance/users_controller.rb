module Clearance
  module UsersController

    def self.included(base)
      base.class_eval do
        before_filter :authenticate
        before_filter :redirect_to_root, :only => [:new, :create], :if => :logged_in?
        before_filter :ensure_user_is_accessing_self, :only => [:edit, :update, :show]

        filter_parameter_logging :password
        
        include InstanceMethods
        
      private
        include PrivateInstanceMethods
      end
    end

    module InstanceMethods
      def index
      end
      
      def new
        @user = User.new
      end
      
      def show
        @user = User.find params[:id]
      end
      
      def create
        @user = User.new params[:user]
        if @user.save
          current_user = @user
          flash[:notice] = "User created and logged in."
          redirect_back_or root_url
        else
          render :action => "new"
        end
      end

      def edit
        @user = User.find params[:id]
      end
      
      def update
        @user = User.find params[:id]
        
        if @user.update_attributes params[:user]
          flash[:notice] = "User updated."
          redirect_back_or root_url
        else
          render :action => "edit"
        end
      end

      def destroy
        @user = User.find params[:id]
        @user.destroy
        redirect_to root_url
      end
    end

    module PrivateInstanceMethods
      def ensure_user_is_accessing_self
        return if current_user and current_user.respond_to?(:admin?) and current_user.admin?
        deny_access 'You cannot edit that user.' unless current_user.id.to_i == params[:id].to_i
      end
    end

  end
end
