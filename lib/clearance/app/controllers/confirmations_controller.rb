module Clearance
  module App
    module Controllers
      module ConfirmationsController

        def self.included(controller)
          controller.send(:include, Actions)
          controller.send(:include, PrivateMethods)

          controller.class_eval do
            before_filter :forbid_confirmed_user,    :only => :new
            before_filter :forbid_missing_token,     :only => :new
            before_filter :forbid_non_existant_user, :only => :new
            filter_parameter_logging :token
          end
        end

        module Actions
          def new
            create
          end

          def create
            @user = User.find_by_id_and_token(params[:user_id], params[:token])
            @user.confirm_email!

            sign_user_in(@user)
            flash[:success] = "Confirmed email and signed in."
            redirect_to url_after_create
          end
        end

        module PrivateMethods
          private

          def forbid_confirmed_user
            user = User.find_by_id(params[:user_id])
            if user && user.email_confirmed?
              raise ActionController::Forbidden, "confirmed user"
            end
          end

          def forbid_missing_token
            if params[:token].blank?
              raise ActionController::Forbidden, "missing token"
            end
          end

          def forbid_non_existant_user
            unless User.find_by_id_and_token(params[:user_id], params[:token])
              raise ActionController::Forbidden, "non-existant user"
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
