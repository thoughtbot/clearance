require "spec_helper"

describe Clearance::PasswordsController do
  it { is_expected.to be_a Clearance::BaseController }

  describe "#new" do
    it "renders the password reset form" do
      get :new

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "email corresponds to an existing user" do
      it "sends the password reset email" do
        ActionMailer::Base.deliveries.clear
        user = create(:user)

        post :create, params: {
          password: { email: user.email },
        }

        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to match(/change your password/i)
      end
    end

    context "email does not belong to an existing user" do
      it "does not deliver an email" do
        ActionMailer::Base.deliveries.clear
        email = "this_user_does_not_exist@non_existent_domain.com"

        post :create, params: {
          password: { email: email },
        }

        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "still responds with success so as not to leak registered users" do
        email = "this_user_does_not_exist@non_existent_domain.com"

        post :create, params: {
          password: { email: email },
        }

        expect(response).to be_successful
        expect(response).to render_template "passwords/create"
      end
    end
  end

  describe "#edit" do
    context "valid id and token are supplied" do
      it "renders the password form for the user" do
        user = create(:user)

        get :edit, params: {
          user_id: user,
          token: token_for(user)
        }

        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq user
      end
    end

    context "blank token is supplied" do
      it "renders the new password reset form with a flash alert" do
        get :edit, params: {
          user_id: 1,
          token: "",
        }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to match(/expired or is invalid/i)
      end
    end

    context "invalid token is supplied" do
      it "renders the new password reset form with a flash alert" do
        get :edit, params: {
          user_id: 1,
          token: "a"
        }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to match(/expired or is invalid/i)
      end
    end

    context "expired token is supplied" do
      it "does not allow password reset to continue" do
        user = create(:user)
        token = token_for(user)

        Timecop.freeze(1.day.from_now) do
          get :edit, params: {
            user_id: 1,
            token: token
          }

          expect(response).to render_template(:new)
          expect(flash.now[:alert]).to match(/expired or is invalid/i)
        end
      end
    end

    context "password is changed before reset is complete" do
      it "does not allow password reset to continue" do
        user = create(:user)
        token = token_for(user)
        user.update_password("foobar")

        get :edit, params: {
          user_id: 1,
          token: token
        }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to match(/expired or is invalid/i)
      end
    end
  end

  describe "#update" do
    context "valid id, token, and new password provided" do
      it "updates the user's password" do
        user = create(:user)
        old_encrypted_password = user.encrypted_password

        put :update, params: update_parameters(
          user,
          new_password: "my_new_password",
        )

        expect(user.reload.encrypted_password).not_to eq old_encrypted_password
      end
    end

    context "password update fails" do
      it "does not update the password" do
        user = create(:user)
        old_encrypted_password = user.encrypted_password

        put :update, params: update_parameters(
          user,
          new_password: "",
        )

        user.reload
        expect(user.encrypted_password).to eq old_encrypted_password
      end

      it "re-renders the password edit form" do
        user = create(:user)

        put :update, params: update_parameters(
          user,
          new_password: ""
        )

        expect(flash.now[:alert]).to match(/password can't be blank/i)
        expect(response).to render_template(:edit)
        expect(cookies[:remember_token]).to be_nil
      end
    end
  end

  def update_parameters(user, options = {})
    new_password = options.fetch(:new_password)

    {
      user_id: user,
      token: token_for(user),
      password_reset: { password: new_password },
    }
  end

  def token_for(user)
    Clearance::PasswordResetToken.generate_for(user)
  end
end
