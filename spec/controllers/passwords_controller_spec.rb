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
      it "generates a password change token" do
        user = create(:user)

        post :create, params: {
          password: { email: user.email.upcase },
        }

        expect(user.reload.confirmation_token).not_to be_nil
      end

      it "sends the password reset email" do
        ActionMailer::Base.deliveries.clear
        user = create(:user)

        post :create, params: {
          password: { email: user.email },
        }

        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to match(I18n.t("passwords.edit.title"))
      end

      it "re-renders the page when turbo is enabled" do
        user = create(:user)

        post :create, params: {
          password: { email: user.email.upcase },
        }

        expect(response).to have_http_status(:accepted)
      end
    end

    context "email param is missing" do
      it "displays flash error on new page" do
        post :create, params: {
          password: {},
        }

        expect(flash.now[:alert]).to match(I18n.t("flashes.failure_when_missing_email"))
        expect(response).to render_template(:new)
      end

      it "re-renders the page when turbo is enabled" do
        post :create, params: {
          password: {},
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "email param is blank" do
      it "displays flash error on new page" do
        post :create, params: {
          password: {
            email: "",
          },
        }

        expect(flash.now[:alert]).to match(I18n.t("flashes.failure_when_missing_email"))
        expect(response).to render_template(:new)
      end

      it "re-renders the page when turbo is enabled" do
        post :create, params: {
          password: {
            email: "",
          },
        }

        expect(response).to have_http_status(:unprocessable_entity)
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

      it "still responds with error so as not to leak registered users" do
        email = "this_user_does_not_exist@non_existent_domain.com"

        post :create, params: {
          password: { email: email },
        }

        expect(response).to be_successful
        expect(response).to render_template "passwords/create"
      end

      it "has the same status code as a successful request" do
        email = "this_user_does_not_exist@non_existent_domain.com"

        post :create, params: {
          password: { email: email },
        }

        expect(response).to have_http_status(:accepted)
      end
    end
  end

  describe "#edit" do
    context "valid id and token are supplied in url" do
      it "redirects to the edit page with token now removed from url" do
        user = create(:user, :with_forgotten_password)

        get :edit, params: {
          user_id: user,
          token: user.confirmation_token,
        }

        expect(response).to be_redirect
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to edit_user_password_url(user)
        expect(session[:password_reset_token]).to eq user.confirmation_token
      end
    end

    context "valid id in url and valid token in session" do
      it "renders the password reset form" do
        user = create(:user, :with_forgotten_password)

        request.session[:password_reset_token] = user.confirmation_token
        get :edit, params: {
          user_id: user,
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
        expect(flash.now[:alert]).to match(I18n.t("flashes.failure_when_forbidden"))
      end
    end

    context "invalid token is supplied" do
      it "renders the new password reset form with a flash alert" do
        user = create(:user, :with_forgotten_password)

        get :edit, params: {
          user_id: 1,
          token: user.confirmation_token + "a",
        }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to match(I18n.t("flashes.failure_when_forbidden"))
      end
    end

    context "old token in session and recent token in params" do
      it "updates password reset session and redirect to edit page" do
        user = create(:user, :with_forgotten_password)
        request.session[:password_reset_token] = user.confirmation_token

        user.forgot_password!
        get :edit, params: {
          user_id: user.id,
          token: user.reload.confirmation_token,
        }

        expect(response).to redirect_to(edit_user_password_url(user))
        expect(session[:password_reset_token]).to eq(user.confirmation_token)
      end
    end
  end

  describe "#update" do
    context "valid id, token, and new password provided" do
      it "updates the user's password" do
        user = create(:user, :with_forgotten_password)
        old_encrypted_password = user.encrypted_password

        put :update, params: update_parameters(
          user,
          new_password: "my_new_password",
        )

        expect(user.reload.encrypted_password).not_to eq old_encrypted_password
        expect(response).to have_http_status(:see_other)
      end

      it "signs in the user" do
        user = create(:user, :with_forgotten_password)

        put :update, params: update_parameters(
          user,
          new_password: "my_new_password",
        )

        expect(current_user).to eq(user)
      end

      context "when Clearance is configured to not sign in the user" do
        it "doesn't sign in the user" do
          Clearance.configure do |config|
            config.sign_in_on_password_reset = false
          end

          user = create(:user, :with_forgotten_password)

          put :update, params: update_parameters(
            user,
            new_password: "my_new_password",
          )

          expect(current_user).to be_nil
        end
      end
    end

    context "password update fails" do
      it "does not update the password" do
        user = create(:user, :with_forgotten_password)
        old_encrypted_password = user.encrypted_password

        put :update, params: update_parameters(
          user,
          new_password: "",
        )

        user.reload
        expect(user.encrypted_password).to eq old_encrypted_password
        expect(user.confirmation_token).to be_present
      end

      it "does not raise NoMethodError from incomplete password_reset params" do
        user = create(:user, :with_forgotten_password)

        expect do
          put :update, params: {
            user_id: user,
            token: user.confirmation_token,
            password_reset: {},
          }
        end.not_to raise_error
      end

      it "re-renders the password edit form" do
        user = create(:user, :with_forgotten_password)

        put :update, params: update_parameters(
          user,
          new_password: "",
        )

        expect(flash.now[:alert]).to match(I18n.t("flashes.failure_after_update"))
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "doesn't sign in the user" do
        user = create(:user, :with_forgotten_password)

        put :update, params: update_parameters(
          user,
          new_password: "",
        )

        expect(current_user).to be_nil
      end
    end
  end

  def update_parameters(user, options = {})
    new_password = options.fetch(:new_password)

    {
      user_id: user,
      token: user.confirmation_token,
      password_reset: { password: new_password }
    }
  end

  def current_user
    request.env[:clearance].current_user
  end
end
