require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  tests Clearance::UsersController

  should filter_param(:password)

  context "when signed out" do
    setup { sign_out }

    context "on GET to #new" do
      setup { get :new }

      should respond_with(:success)
      should render_template(:new)
      should_not set_the_flash
    end

    context "on GET to #new with email" do
      setup do
        @email = "a@example.com"
        get :new, :user => { :email => @email }
      end

      should "set assigned user's email" do
        assert_equal @email, assigns(:user).email
      end
    end

    context "on POST to #create with valid attributes" do
      setup do
        user_attributes = Factory.attributes_for(:user)
        @old_user_count = User.count
        post :create, :user => user_attributes
      end

      should assign_to(:user)

      should "create a new user" do
        assert_equal @old_user_count + 1, User.count
      end

      should have_sent_email.with_subject(/account confirmation/i)

      should set_the_flash.to(/confirm/i)
      should_redirect_to_url_after_create
    end
  end

  context "A signed-in user" do
    setup do
      @user = Factory(:email_confirmed_user)
      sign_in_as @user
    end

    context "GET to new" do
      setup { get :new }
      should redirect_to("the home page") { root_url }
    end

    context "POST to create" do
      setup { post :create, :user => {} }
      should redirect_to("the home page") { root_url }
    end
  end

end
