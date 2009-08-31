require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

  tests Clearance::PasswordsController

  should_route :get, '/users/1/password/edit',
    :controller => 'clearance/passwords', :action  => 'edit', :user_id => '1'

  context "a signed up user" do
    setup do
      @user = Factory(:user)
    end

    context "on GET to #new" do
      setup { get :new, :user_id => @user.to_param }

      should_respond_with :success
      should_render_template "new"
    end

    context "on POST to #create" do
      context "with correct email address" do
        setup do
          ActionMailer::Base.deliveries.clear
          post :create, :password => { :email => @user.email }
        end

        should "generate a token for the change your password email" do
          assert_not_nil @user.reload.confirmation_token
        end

        should "send the change your password email" do
          assert_sent_email do |email|
            email.subject =~ /change your password/i
          end
        end

        should_set_the_flash_to /password/i
        should_redirect_to_url_after_create
      end

      context "with incorrect email address" do
        setup do
          email = "user1@example.com"
          assert ! ::User.exists?(['email = ?', email])
          ActionMailer::Base.deliveries.clear
          assert_equal @user.confirmation_token,
                       @user.reload.confirmation_token

          post :create, :password => { :email => email }
        end

        should "not generate a token for the change your password email" do
          assert_equal @user.confirmation_token,
                       @user.reload.confirmation_token
        end

        should "not send a password reminder email" do
          assert ActionMailer::Base.deliveries.empty?
        end

        should "set the failure flash to Unknown email" do
          assert_match /unknown email/i, flash.now[:failure]
        end

        should_render_template :new
      end
    end
  end

  context "a signed up user and forgotten password" do
    setup do
      @user = Factory(:user)
      @user.forgot_password!
    end

    context "on GET to #edit with correct id and token" do
      setup do
        get :edit, :user_id => @user.to_param,
                   :token   => @user.confirmation_token
      end

      should "find the user" do
        assert_equal @user, assigns(:user)
      end

      should_respond_with :success
      should_render_template "edit"
      should_display_a_password_update_form
    end

    should_forbid "on GET to #edit with correct id but blank token" do
      get :edit, :user_id => @user.to_param, :token => ""
    end

    should_forbid "on GET to #edit with correct id but no token" do
      get :edit, :user_id => @user.to_param
    end

    context "on PUT to #update with matching password and password confirmation" do
      setup do
        new_password = "new_password"
        @encrypted_new_password = @user.send(:encrypt, new_password)
        assert_not_equal @encrypted_new_password, @user.encrypted_password

        put(:update,
            :user_id  => @user,
            :token    => @user.confirmation_token,
            :user     => {
              :password              => new_password,
              :password_confirmation => new_password
            })
        @user.reload
      end

      should "update password" do
        assert_equal @encrypted_new_password,
                     @user.encrypted_password
      end

      should "clear confirmation token" do
        assert_nil @user.confirmation_token
      end

      should "set remember token" do
        assert_not_nil @user.remember_token
      end

      should_set_the_flash_to(/signed in/i)
      should_redirect_to_url_after_update
    end

    context "on PUT to #update with password but blank password confirmation" do
      setup do
        new_password = "new_password"
        @encrypted_new_password = @user.send(:encrypt, new_password)

        put(:update,
            :user_id => @user.to_param,
            :token   => @user.confirmation_token,
            :user    => {
              :password => new_password,
              :password_confirmation => ''
            })
        @user.reload
      end

      should "not update password" do
        assert_not_equal @encrypted_new_password,
                         @user.encrypted_password
      end

      should "not clear token" do
        assert_not_nil @user.confirmation_token
      end

      should_not_be_signed_in
      should_not_set_the_flash
      should_respond_with    :success
      should_render_template :edit

      should_display_a_password_update_form
    end

    should_forbid "on PUT to #update with id but no token" do
      put :update, :user_id => @user.to_param, :token => ""
    end
  end

  context "given two users and user one signs in" do
    setup do
      @user_one = Factory(:user)
      @user_two = Factory(:user)
      sign_in_as @user_one
    end

    should_forbid "when user one tries to change user two's password on GET with no token" do
      get :edit, :user_id => @user_two.to_param
    end
  end

end
