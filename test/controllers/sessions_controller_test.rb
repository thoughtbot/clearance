require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  tests Clearance::SessionsController

  should filter_param(:password)

  context "on GET to /sessions/new" do
    setup { get :new }

    should respond_with(:success)
    should render_template(:new)
    should_not set_the_flash
  end

  context "on POST to #create with good credentials" do
    setup do
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token")
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    should set_the_flash.to(/signed in/i)
    should_redirect_to_url_after_create

    should_set_cookie("remember_token", "old-token", Clearance.configuration.cookie_expiration.call)

    should "have a default of 1 year from now" do
      assert_in_delta Clearance.configuration.cookie_expiration.call, 1.year.from_now, 100
    end

    should "not change the remember token" do
      assert_equal "old-token", @user.reload.remember_token
    end
  end

  context "on POST to #create with good credentials - cookie duration set to 2 weeks" do
    custom_duration = 2.weeks.from_now.utc

    setup do
      Clearance.configuration.cookie_expiration = lambda { custom_duration }
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token2")
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    should_set_cookie("remember_token", "old-token2", custom_duration)

    teardown do
      # restore default Clearance configuration
      Clearance.configuration = nil
      Clearance.configure {}
    end
  end

  context "on POST to #create with good credentials - cookie expiration set to nil (session cookie)" do
    setup do
      Clearance.configuration.cookie_expiration = lambda { nil }
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token3")
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    should_set_cookie("remember_token", "old-token3", nil)

    teardown do
      # restore default Clearance configuration
      Clearance.configuration = nil
      Clearance.configure {}
    end
  end

  context "on POST to #create with good credentials and a session return url" do
    setup do
      @user = Factory(:user)
      @return_url = '/url_in_the_session'
      @request.session[:return_to] = @return_url
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    should redirect_to("the return URL") { @return_url }
  end

  context "on POST to #create with good credentials and a request return url" do
    setup do
      @user = Factory(:user)
      @return_url = '/url_in_the_request'
      post :create, :session => {
                      :email     => @user.email,
                      :password  => @user.password },
                      :return_to => @return_url
    end

    should redirect_to("the return URL") { @return_url }
  end

  context "on POST to #create with good credentials and a session return url and request return url" do
    setup do
      @user = Factory(:user)
      @return_url = '/url_in_the_session'
      @request.session[:return_to] = @return_url
      post :create, :session => {
                      :email     => @user.email,
                      :password  => @user.password },
                      :return_to => '/url_in_the_request'
    end

    should redirect_to("the return URL") { @return_url }
  end

  context "on DELETE to #destroy given a signed out user" do
    setup do
      sign_out
      delete :destroy
    end
    should set_the_flash.to(/signed out/i)
    should_redirect_to_url_after_destroy
  end

  context "on DELETE to #destroy with a cookie" do
    setup do
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token")
      @request.cookies["remember_token"] = "old-token"
      delete :destroy
    end

    should set_the_flash.to(/signed out/i)
    should_redirect_to_url_after_destroy

    should "delete the cookie token" do
      assert_nil cookies['remember_token']
    end

    should "reset the remember token" do
      assert_not_equal "old-token", @user.reload.remember_token
    end

    should "unset the current user" do
      assert_nil @controller.current_user
    end
  end

end
