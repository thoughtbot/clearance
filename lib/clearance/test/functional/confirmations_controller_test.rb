module Clearance
  module Test
    module Functional
      module ConfirmationsControllerTest

        def self.included(base)
          base.class_eval do

            context "Given a User with id and salt" do
              setup do
                @user = Factory(:clearance_user)
              end
              
              context "When GET to #new with correct id and salt" do
                setup do
                  get :new, :user_id => @user.to_param, :salt => @user.salt
                end

                should_be_logged_in_and_confirmed_as "@user"
                should_redirect_to "@controller.send(:url_after_create)"
              end
              
              context "When GET to #new with incorrect id and salt" do
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
