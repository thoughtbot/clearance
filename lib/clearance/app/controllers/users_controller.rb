module Clearance
  module App
    module Controllers
      module UsersController

        def self.included(controller)
          controller.send(:include, Actions)
          controller.send(:include, PrivateMethods)

          controller.class_eval do
            before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?
            filter_parameter_logging :password
          end
        end

        module Actions
          def new
            @user = User.new(params[:user])
          end

          def create
            @user = User.new params[:user]
            if @user.save
              ClearanceMailer.deliver_confirmation @user
              flash[:notice] = "You will receive an email within the next few minutes. " <<
                               "It contains instructions for confirming your account."
              redirect_to url_after_create
            else
              render :action => "new"
            end
          end
        end

        module PrivateMethods
          private

          def url_after_create
            new_session_url
          end
        end

      end
    end
  end
end
