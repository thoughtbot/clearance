module Clearance
  module App
    module Controllers
      module ConfirmationsController
    
        def self.included(base)
          base.class_eval do
            before_filter :existing_user?, :only => [:new, :create]
        
            include InstanceMethods
        
          private
            include PrivateInstanceMethods
          end
        end
    
        module InstanceMethods
          def new
            @user = User.find_by_id_and_salt(params[:user_id], params[:salt])
          end

          def create
            @user = User.find_by_id_and_salt(params[:user_id], params[:salt])
            @user.confirm!
            session[:user_id] = @user.id
            redirect_to url_after_create
          end
        end
    
        module PrivateInstanceMethods
          def existing_user?
            user = User.find_by_id_and_salt(params[:user_id], params[:salt])
            if user.nil?
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