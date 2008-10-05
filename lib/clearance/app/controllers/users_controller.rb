module Clearance
  module UsersController

    def self.included(base)
      base.class_eval do
        before_filter :redirect_to_root, :only => [:new, :create], :if => :logged_in?
        
        filter_parameter_logging :password
        
        include InstanceMethods
        
      private
        include PrivateInstanceMethods
      end
    end

    module InstanceMethods
      def new
        @user = User.new(params[:user])
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
    end

    module PrivateInstanceMethods

      def url_after_create
        root_url
      end
    end

  end
end
