module Clearance
  module Test
    module Functional
      module ConfirmationsControllerTest

        def self.included(controller_test)
          controller_test.class_eval do

            should_filter_params :token

            context "Given a user whose email has not been confirmed" do
              setup { @user = Factory(:user) }
              
              context "on GET to #new with correct id and token" do
                setup do
                  get :new, :user_id => @user.to_param, :token => @user.token
                end

                should_set_the_flash_to /confirmed email/i
                should_set_the_flash_to /signed in/i
                should_be_signed_in_and_email_confirmed_as { @user }
                should_redirect_to_url_after_create
              end

              context "on GET to #new with incorrect token" do
                setup do
                  token = ""
                  assert_not_equal token, @user.token

                  get :new, :user_id => @user.to_param, :token => token
                end

                should_respond_with :not_found
                should_render_nothing
              end
            end

            context "Given a user whose email has been confirmed" do
              setup { @user = Factory(:email_confirmed_user) }

              context "on GET to #new with correct id and token" do
                setup do
                  get :new, :user_id => @user.to_param, :token => @user.token
                end

                should_not_be_signed_in
                should_redirect_to 'new_session_url'
              end

              context "on GET to #new with incorrect token" do
                setup do
                  token = ""
                  assert_not_equal token, @user.token

                  get :new, :user_id => @user.to_param, :token => token
                end

                should_not_be_signed_in
                should_redirect_to 'new_session_url'
              end
            end

            context "Given no user records" do
              setup { assert_equal 0, User.count }
              context "on GET to #new with nonexistent id and token" do
                setup do
                  get :new, :user_id => '123', :token => '123'
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
