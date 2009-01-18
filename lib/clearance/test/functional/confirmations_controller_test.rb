module Clearance
  module Test
    module Functional
      module ConfirmationsControllerTest

        def self.included(controller_test)
          controller_test.class_eval do
            
            should_filter_params :salt
            
            context "Given a user whose email has not been confirmed" do
              setup { @user = Factory(:registered_user) }
              
              context "on GET to #new with correct id and salt" do
                setup do
                  get :new, :user_id => @user.to_param, :salt => @user.salt
                end

                should_be_logged_in_and_email_confirmed_as { @user }
                should_redirect_to_url_after_create
              end
              
              context "on GET to #new with incorrect salt" do
                setup do
                  salt = ""
                  assert_not_equal salt, @user.salt

                  get :new, :user_id => @user.to_param, :salt => salt
                end

                should_respond_with :not_found
                should_render_nothing
              end
            end
          
          end
        end

      end
    end
  end
end
