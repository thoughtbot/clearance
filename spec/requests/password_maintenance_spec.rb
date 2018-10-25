require "spec_helper"

describe "Password maintenance" do
  context "when updating the password" do
    it "signs the user in and redirects" do
      user = create(:user, :with_forgotten_password)

      put user_password_url(user), params: {
        user_id: user,
        token: user.confirmation_token,
        password_reset: { password: "my_new_password" },
      }

      expect(response).to redirect_to(Clearance.configuration.redirect_url)
      expect(cookies[:remember_token]).to be_present
    end
  end
end
