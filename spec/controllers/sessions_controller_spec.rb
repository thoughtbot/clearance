require 'spec_helper'

describe Clearance::SessionsController do
  describe 'on GET to /sessions/new' do
    before { get :new }

    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should_not set_the_flash }
  end

  describe 'on POST to #create with good credentials' do
    before do
      @user = create(:user)
      @user.update_attribute :remember_token, 'old-token'
      post :create, :session => { :email => @user.email, :password => @user.password }
    end

    it { should redirect_to_url_after_create }

    it 'sets the user in the clearance session' do
      controller.current_user.should == @user
    end

    it 'should not change the remember token' do
      @user.reload.remember_token.should == 'old-token'
    end
  end

  describe 'on POST to #create with good credentials and a session return url' do
    before do
      @user = create(:user)
      @return_url = '/url_in_the_session'
      @request.session[:return_to] = @return_url
      post :create, :session => { :email => @user.email, :password => @user.password }
    end

    it 'redirects to the return URL' do
      should redirect_to(@return_url)
    end
  end

  describe 'on POST to #create with good credentials and a request return url' do
    before do
      @user = create(:user)
      @return_url = '/url_in_the_request'
      post :create, :session => { :email => @user.email, :password  => @user.password },
        :return_to => @return_url
    end

    it 'redirects to the return URL' do
      should redirect_to(@return_url)
    end
  end

  describe 'on POST to #create with good credentials and a session return url and request return url' do
    before do
      @user = create(:user)
      @return_url = '/url_in_the_session'
      @request.session[:return_to] = @return_url
      post :create, :session => { :email => @user.email, :password => @user.password },
        :return_to => '/url_in_the_request'
    end

    it 'redirects to the return url' do
      should redirect_to(@return_url)
    end
  end

  describe 'on POST to #create with good credentials and foreign host in the return url' do
    before do
      @user = create(:user)
      @return_path = '/return/path'
      @return_url = "http://badhost.example.com#{@return_path}"
      post :create, :session => { :email => @user.email, :password => @user.password },
        :return_to => @return_url
    end

    it 'only uses the path from the return url' do
      should redirect_to(@return_path)
    end
  end

  describe 'on DELETE to #destroy given a signed out user' do
    before do
      sign_out
      delete :destroy
    end

    it { should redirect_to_url_after_destroy }
  end

  describe 'on DELETE to #destroy with a cookie' do
    before do
      @user = create(:user)
      @user.update_attribute :remember_token, 'old-token'
      @request.cookies['remember_token'] = 'old-token'
      delete :destroy
    end

    it { should redirect_to_url_after_destroy }

    it 'should reset the remember token' do
      @user.reload.remember_token.should_not == 'old-token'
    end

    it 'should unset the current user' do
      @controller.current_user.should be_nil
    end
  end
end
