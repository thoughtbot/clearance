require 'spec_helper'

describe Clearance::PasswordsController do
  it { is_expected.to be_a Clearance::BaseController }

  describe 'a signed up user' do
    before do
      @user = create(:user)
    end

    describe 'on GET to #new' do
      before { get :new, user_id: @user.to_param }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:new) }
    end

    describe 'on POST to #create' do
      describe 'with correct email address' do
        before do
          ActionMailer::Base.deliveries.clear
          post :create, password: { email: @user.email }
        end

        it 'should generate a token for the change your password email' do
          expect(@user.reload.confirmation_token).not_to be_nil
        end

        it 'sends an email with relevant subject' do
          email = ActionMailer::Base.deliveries.last
          expect(email.subject).to match(/change your password/i)
        end

        it { is_expected.to respond_with(:success) }
      end

      describe 'with correct email address capitalized differently' do
        before do
          ActionMailer::Base.deliveries.clear
          post :create, password: { email: @user.email.upcase }
        end

        it 'should generate a token for the change your password email' do
          expect(@user.reload.confirmation_token).not_to be_nil
        end

        it 'sends an email with relevant subject' do
          email = ActionMailer::Base.deliveries.last
          expect(email.subject).to match(/change your password/i)
        end

        it { is_expected.to respond_with(:success) }
      end

      describe 'with incorrect email address' do
        before do
          email = 'user1@example.com'
          user = Clearance.configuration.user_model.exists?(email: email)
          expect(user).not_to be_present

          ActionMailer::Base.deliveries.clear
          expect(@user.reload.confirmation_token).to eq @user.confirmation_token

          post :create, password: { email: email }
        end

        it 'should not generate a token for the change your password email' do
          expect(@user.reload.confirmation_token).to eq @user.confirmation_token
        end

        it 'should not send a password reminder email' do
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it { is_expected.to render_template(:create) }
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
        get :edit,
            user_id: @user.to_param,
            token: @user.confirmation_token
      end

      it 'should find the user' do
        expect(assigns(:user)).to eq @user
      end

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
    end

    describe 'on GET to #edit with correct id but blank token' do
      before do
        get :edit, user_id: @user.to_param, token: ''
      end

      it { is_expected.to set_the_flash.to(/double check the URL/i).now }
      it { is_expected.to render_template(:new) }
    end

    describe 'on GET to #edit with correct id but no token' do
      before do
        get :edit, user_id: @user.to_param
      end

      it { is_expected.to set_the_flash.to(/double check the URL/i).now }
      it { is_expected.to render_template(:new) }
    end

    describe 'on PUT to #update with password' do
      before do
        @new_password = 'new_password'
        @old_encrypted_password = @user.encrypted_password

        put :update, user_id: @user, token: @user.confirmation_token,
          password_reset: { password: @new_password }
        @user.reload
      end

      it 'should update password' do
        expect(@user.encrypted_password.to_s).not_to eq @old_encrypted_password
      end

      it 'should clear confirmation token' do
        expect(@user.confirmation_token).to be_nil
      end

      it 'should set remember token' do
        expect(@user.remember_token).not_to be_nil
      end

      it { is_expected.to redirect_to_url_after_update }
    end

    describe 'on PUT to #update with blank password' do
      before do
        put :update, user_id: @user.to_param, token: @user.confirmation_token,
          password_reset: { password: '' }
        @user.reload
      end

      it 'should not update password to be blank' do
        expect(@user.encrypted_password).not_to be_blank
      end

      it 'should not clear token' do
        expect(@user.confirmation_token).not_to be_nil
      end

      it 'should not be signed in' do
        expect(cookies[:remember_token]).to be_nil
      end

      it { is_expected.to set_the_flash.to(/password can't be blank/i).now }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
    end

    describe 'on PUT to #update with an empty token after the user sets a password' do
      before do
        put :update, user_id: @user.to_param, token: @user.confirmation_token,
          password_reset: { password: 'good password' }
        put :update, user_id: @user.to_param, token: [nil],
          password_reset: { password: 'new password' }
      end

      it { is_expected.to set_the_flash.to(/double check the URL/i).now }
      it { is_expected.to render_template(:new) }
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
