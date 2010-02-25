require 'test_helper'

class ConfirmationsControllerTest < ActionController::TestCase

  tests Clearance::ConfirmationsController

  should_filter_params :token

  context "a user whose email has not been confirmed" do
    setup { @user = Factory(:user) }

    should "have a token" do
      assert_not_nil @user.confirmation_token
      assert_not_equal "", @user.confirmation_token
    end

    context "on GET to #new with correct id and token" do
      setup do
        get :new, :user_id => @user.to_param,
                  :token   => @user.confirmation_token
      end

      should_set_the_flash_to /confirmed email/i
      should_set_the_flash_to /signed in/i
      should_redirect_to_url_after_create

      should "set the current user" do
        assert_equal @user, @controller.current_user
      end
    end

    context "with an incorrect token" do
      setup do
        @bad_token = "bad token"
        assert_not_equal @bad_token, @user.confirmation_token
      end

      should_forbid "on GET to #new with incorrect token" do
        get :new, :user_id => @user.to_param,
                  :token   => @bad_token
      end
    end

    should_forbid "on GET to #new with blank token" do
      get :new, :user_id => @user.to_param, :token => ""
    end

    should_forbid "on GET to #new with no token" do
      get :new, :user_id => @user.to_param
    end
  end

  context "a signed in confirmed user on GET to #new with token" do
    setup do
      @user  = Factory(:user)
      @token = @user.confirmation_token
      @user.confirm_email!
      sign_in_as @user

      get :new, :user_id => @user.to_param, :token => @token
    end

    should_set_the_flash_to /confirmed email/i
    should_redirect_to_url_after_create
  end

  context "a bad user" do
    setup do
      @user  = Factory(:user)
      @token = @user.confirmation_token
      @user.confirm_email!

      @bad_user = Factory(:email_confirmed_user)
      sign_in_as @bad_user
    end

    should_forbid "on GET to #new with token for another user" do
      get :new, :user_id => @user.to_param, :token => @token
    end
  end

  context "a signed out confirmed user on GET to #new with token" do
    setup do
      @user  = Factory(:user)
      @token = @user.confirmation_token
      @user.confirm_email!
      get :new, :user_id => @user.to_param, :token => @token
    end

    should_set_the_flash_to /already confirmed/i
    should_set_the_flash_to /sign in/i
    should_not_be_signed_in
    should_redirect_to_url_already_confirmed
  end

  context "no users" do
    setup { assert_equal 0, ::User.count }

    should_forbid "on GET to #new with nonexistent id and token" do
      get :new, :user_id => '123', :token => '123'
    end
  end

end
