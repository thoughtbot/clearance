require "spec_helper"

describe "Password maintenance" do
  context "when updating the password" do
    it "signs the user in and redirects" do
      user = create(:user)

      put user_password_url(user), params: {
        user_id: user,
        token: token_for(user),
        password_reset: { password: "my_new_password" },
      }

      expect(response).to redirect_to(Clearance.configuration.redirect_url)
      expect(cookies["remember_token"]).to be_present
    end

    def token_for(user)
      Clearance.configuration.message_verifier.generate([
        user.id,
        user.encrypted_password,
        15.minutes.from_now,
      ])
    end
  end
end
