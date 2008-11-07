module Clearance
  module App
    module Controllers
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
            @user = user_model.new(params[:user])
          end
      
          def create
            @user = user_model.new params[:user]
            if @user.save
              ClearanceMailer.deliver_confirmation @user
              flash[:notice] = "You will receive an email within the next few minutes. It contains instructions for you to confirm your account."
              redirect_to url_after_create
            else
              render :action => "new"
            end
          end
        end

        module PrivateInstanceMethods

          def url_after_create
            new_session_url
          end
        
        end

      end
    end
  end
end
