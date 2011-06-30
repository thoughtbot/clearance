require 'spec_helper'

describe Clearance::SessionsController do
  describe "on GET to /sessions/new" do
    before { get :new }

    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should_not set_the_flash }
  end

  describe "on POST to #create with good credentials" do
    before do
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token")
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    it { should redirect_to_url_after_create }

    it "sets a remember token cookie" do
      should set_cookie("remember_token", "old-token", Clearance.configuration.cookie_expiration.call)
    end

    it "should have a default of 1 year from now" do
      Clearance.configuration.cookie_expiration.call.should be_within(100).of(1.year.from_now)
    end

    it "should not change the remember token" do
      @user.reload.remember_token.should == "old-token"
    end
  end

  describe "on POST to #create with good credentials - cookie duration set to 2 weeks" do
    custom_duration = 2.weeks.from_now.utc

    before do
      Clearance.configuration.cookie_expiration = lambda { custom_duration }
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token2")
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    it "sets a remember token cookie" do
      should set_cookie("remember_token", "old-token2", custom_duration)
    end

    after do
      # restore default Clearance configuration
      Clearance.configuration = nil
      Clearance.configure {}
    end
  end

  describe "on POST to #create with good credentials - cookie expiration set to nil (session cookie)" do
    before do
      Clearance.configuration.cookie_expiration = lambda { nil }
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token3")
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    it "unsets a remember token cookie" do
      should set_cookie("remember_token", "old-token3", nil)
    end

    after do
      # restore default Clearance configuration
      Clearance.configuration = nil
      Clearance.configure {}
    end
  end

  describe "on POST to #create with good credentials and a session return url" do
    before do
      @user = Factory(:user)
      @return_url = '/url_in_the_session'
      @request.session[:return_to] = @return_url
      post :create, :session => {
                      :email    => @user.email,
                      :password => @user.password }
    end

    it "redirects to the return URL" do
      should redirect_to(@return_url)
    end
  end

  describe "on POST to #create with good credentials and a request return url" do
    before do
      @user = Factory(:user)
      @return_url = '/url_in_the_request'
      post :create, :session => {
                      :email     => @user.email,
                      :password  => @user.password },
                      :return_to => @return_url
    end

    it "redirects to the return URL" do
      should redirect_to(@return_url)
    end
  end

  describe "on POST to #create with good credentials and a session return url and request return url" do
    before do
      @user = Factory(:user)
      @return_url = '/url_in_the_session'
      @request.session[:return_to] = @return_url
      post :create, :session => {
                      :email     => @user.email,
                      :password  => @user.password },
                      :return_to => '/url_in_the_request'
    end

    it "redirects to the return url" do
      should redirect_to(@return_url)
    end
  end

  describe "on DELETE to #destroy given a signed out user" do
    before do
      sign_out
      delete :destroy
    end
    it { should redirect_to_url_after_destroy }
  end

  describe "on DELETE to #destroy with a cookie" do
    before do
      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token")
      @request.cookies["remember_token"] = "old-token"
      delete :destroy
    end

    it { should redirect_to_url_after_destroy }

    it "should delete the cookie token" do
      cookies['remember_token'].should be_nil
    end

    it "should reset the remember token" do
      @user.reload.remember_token.should_not == "old-token"
    end

    it "should unset the current user" do
      @controller.current_user.should be_nil
    end
  end
end
