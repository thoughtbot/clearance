require 'spec_helper'

describe Clearance::UsersController do
  it { should be_a Clearance::BaseController }

  describe 'when signed out' do
    before { sign_out }

    describe 'on GET to #new' do
      before { get :new }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:new) }
      it { is_expected.not_to set_the_flash }
    end

    describe 'on GET to #new with email' do
      before do
        @email = 'a@example.com'
        get :new, user: { email: @email }
      end

      it 'should set assigned user email' do
        expect(assigns(:user).email).to eq @email
      end
    end

    describe 'on POST to #create with valid attributes' do
      before do
        user_attributes = FactoryGirl.attributes_for(:user)
        @old_user_count = User.count
        post :create, user: user_attributes
      end

      it 'assigns a user' do
        expect(assigns(:user)).to be_present
      end

      it 'should create a new user' do
        expect(User.count).to eq @old_user_count + 1
      end

      it { should redirect_to_url_after_create }
    end

    describe 'on POST to #create with valid attributes and a session return url' do
      before do
        user_attributes = FactoryGirl.attributes_for(:user)
        @old_user_count = User.count
        @return_url = '/url_in_the_session'
        @request.session[:return_to] = @return_url
        post :create, user: user_attributes
      end

      it 'assigns a user' do
        expect(assigns(:user)).to be_present
      end

      it 'should create a new user' do
        expect(User.count).to eq @old_user_count + 1
      end

      it { should redirect_to(@return_url) }
    end
  end

  describe 'A signed-in user' do
    before do
      @user = create(:user)
      sign_in_as @user
    end

    describe 'GET to new' do
      before { get :new }

      it 'redirects to the home page' do
        should redirect_to(Clearance.configuration.redirect_url)
      end
    end

    describe 'POST to create' do
      before { post :create, user: {} }

      it 'redirects to the home page' do
        should redirect_to(Clearance.configuration.redirect_url)
      end
    end
  end
end
