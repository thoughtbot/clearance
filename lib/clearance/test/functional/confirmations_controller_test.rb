module Clearance
  module Test
    module Functional
      module ConfirmationsControllerTest

        def self.included(controller_test)
          controller_test.class_eval do

            should_filter_params :token

            context "a user whose email has not been confirmed" do
              setup { @user = Factory(:user) }

              should "have a token" do
                assert_not_nil @user.token
                assert_not_equal "", @user.token
              end

              context "on GET to #new with correct id and token" do
                setup do
                  get :new, :user_id => @user.to_param, :token => @user.token
                end

                should_set_the_flash_to /confirmed email/i
                should_set_the_flash_to /signed in/i
                should_be_signed_in_and_email_confirmed_as { @user }
                should_redirect_to_url_after_create
              end

              context "with an incorrect token" do
                setup do
                  @bad_token = "bad token"
                  assert_not_equal @bad_token, @user.token
                end

                should_forbid "on GET to #new with incorrect token" do
                  get :new, :user_id => @user.to_param, :token => @bad_token
                end
              end

              should_forbid "on GET to #new with blank token" do
                get :new, :user_id => @user.to_param, :token => ""
              end

              should_forbid "on GET to #new with no token" do
                get :new, :user_id => @user.to_param
              end
            end

            context "a user with email confirmed" do
              setup { @user = Factory(:email_confirmed_user) }

              should_forbid "on GET to #new with correct id" do
                get :new, :user_id => @user.to_param
              end
            end

            context "no users" do
              setup { assert_equal 0, User.count }

              should_forbid "on GET to #new with nonexistent id and token" do
                get :new, :user_id => '123', :token => '123'
              end
            end

          end
        end

      end
    end
  end
end
