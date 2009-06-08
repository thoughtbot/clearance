require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  tests Clearance::UsersController

  should_filter_params :password

  context "when signed out" do
    setup { sign_out }

    context "on GET to #new" do
      setup { get :new }

      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash

      should_display_a_sign_up_form
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
        post :create, :user => user_attributes
      end

      should_create_user_successfully
    end
  end

  signed_in_user_context do
    context "GET to new" do
      setup { get :new }
      should_redirect_to("the home page") { root_url }
    end

    context "POST to create" do
      setup { post :create, :user => {} }
      should_redirect_to("the home page") { root_url }
    end
  end

end
