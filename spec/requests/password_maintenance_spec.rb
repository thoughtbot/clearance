require "spec_helper"

describe "Password maintenance" do
  context "when updating the password" do
    let(:user) { create(:user, :with_forgotten_password) }

    before(:each) do
      Clearance.configure do |config|
        config.sign_in_on_password_reset = sign_in_on_password_reset
      end

      put user_password_url(user), params: {
        user_id: user,
        token: user.confirmation_token,
        password_reset: { password: "my_new_password" },
      }
    end

    context "if `sign_in_on_password_reset` option is true" do
      let(:sign_in_on_password_reset) { true }

      it "signs the user in and redirects" do
        expect(response).to redirect_to(Clearance.configuration.redirect_url)
        expect(cookies["remember_token"]).to be_present
      end
    end

    context "if `sign_in_on_password_reset` option is false" do
      let(:sign_in_on_password_reset) { false }

      it "redirects, but does not sign in the user" do
        expect(response).to redirect_to(Clearance.configuration.redirect_url)
        expect(cookies["remember_token"]).not_to be_present
      end
    end
  end
end
