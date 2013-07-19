require 'spec_helper'

describe Clearance::PasswordsController do
  describe 'a signed up user' do
    before do
      @user = create(:user)
    end

    describe 'on GET to #new' do
      before { get :new, :user_id => @user.to_param }

      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    describe 'on POST to #create' do
      describe 'with correct email address' do
        before do
          ActionMailer::Base.deliveries.clear
          post :create, :password => { :email => @user.email }
        end

        it 'should generate a token for the change your password email' do
          @user.reload.confirmation_token.should_not be_nil
        end

        it 'sends an email with relevant subject' do
          email = ActionMailer::Base.deliveries.last
          email.subject.should match(/change your password/i)
        end

        it { should respond_with(:success) }
      end

      describe 'with correct email address capitalized differently' do
        before do
          ActionMailer::Base.deliveries.clear
          post :create, :password => { :email => @user.email.upcase }
        end

        it 'should generate a token for the change your password email' do
          @user.reload.confirmation_token.should_not be_nil
        end

        it 'sends an email with relevant subject' do
          email = ActionMailer::Base.deliveries.last
          email.subject.should match(/change your password/i)
        end

        it { should respond_with(:success) }
      end

      describe 'with incorrect email address' do
        before do
          email = 'user1@example.com'
          (Clearance.configuration.user_model.exists?(['email = ?', email])).should_not be
          ActionMailer::Base.deliveries.clear
          @user.reload.confirmation_token.should == @user.confirmation_token

          post :create, :password => { :email => email }
        end

        it 'should not generate a token for the change your password email' do
          @user.reload.confirmation_token.should == @user.confirmation_token
        end

        it 'should not send a password reminder email' do
          ActionMailer::Base.deliveries.should be_empty
        end

        it { should render_template(:create) }
      end
    end
  end

  describe 'a signed up user and forgotten password' do
    before do
      @user = create(:user)
      @user.forgot_password!
    end

    describe 'on GET to #edit with correct id and token' do
      before do
        get :edit, :user_id => @user.to_param,
          :token => @user.confirmation_token
      end

      it 'should find the user' do
        assigns(:user).should == @user
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    describe 'on GET to #edit with correct id but blank token' do
      before do
        get :edit, :user_id => @user.to_param, :token => ''
      end

      it { should set_the_flash.to(/double check the URL/i).now }
      it { should render_template(:new) }
    end

    describe 'on GET to #edit with correct id but no token' do
      before do
        get :edit, :user_id => @user.to_param
      end

      it { should set_the_flash.to(/double check the URL/i).now }
      it { should render_template(:new) }
    end

    describe 'on PUT to #update with password' do
      before do
        @new_password = 'new_password'
        @old_encrypted_password = @user.encrypted_password

        put :update, :user_id => @user, :token => @user.confirmation_token,
          :password_reset => { :password => @new_password }
        @user.reload
      end

      it 'should update password' do
        @user.encrypted_password.to_s.should_not eq @old_encrypted_password
      end

      it 'should clear confirmation token' do
        @user.confirmation_token.should be_nil
      end

      it 'should set remember token' do
        @user.remember_token.should_not be_nil
      end

      it { should redirect_to_url_after_update }
    end

    describe 'on PUT to #update with blank password' do
      before do
        put :update, :user_id => @user.to_param, :token => @user.confirmation_token,
          :password_reset => { :password => '' }
        @user.reload
      end

      it 'should not update password to be blank' do
        @user.encrypted_password.should_not be_blank
      end

      it 'should not clear token' do
        @user.confirmation_token.should_not be_nil
      end

      it 'should not be signed in' do
        cookies[:remember_token].should be_nil
      end

      it { should set_the_flash.to(/password can't be blank/i).now }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    describe 'on PUT to #update with an empty token after the user sets a password' do
      before do
        put :update, :user_id => @user.to_param, :token => @user.confirmation_token,
          :password_reset => { :password => 'good password' }
        put :update, :user_id => @user.to_param, :token => [nil],
          :password_reset => { :password => 'new password' }
      end

      it { should set_the_flash.to(/double check the URL/i).now }
      it { should render_template(:new) }
    end
  end

  describe 'given two users and user one signs in' do
    before do
      @user_one = create(:user)
      @user_two = create(:user)
      sign_in_as @user_one
    end
  end
end
