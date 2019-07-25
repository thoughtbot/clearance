require "spec_helper"

describe Clearance::PasswordResetToken do
  describe ".generate_for" do
    it "uses the configured message verifier to generate a token" do
      Timecop.freeze do
        user = double("User", id: 1, encrypted_password: "foo")
        time_limit = Clearance.configuration.password_reset_time_limit
        tokenizer = double

        allow(Clearance.configuration.tokenizer).to receive(:new).
          and_return(tokenizer)
        allow(tokenizer).to receive(:generate).
          with(1, expires_in: time_limit).
          and_return("SEKRET")

        token = Clearance::PasswordResetToken.generate_for(user)

        expect(token.to_s).to eq "SEKRET"
      end
    end
  end

  describe ".find_user" do
    it "is the user if signature is valid and token is not expired" do
      user = create(:user)
      token = Clearance::PasswordResetToken.generate_for(user)

      expect(Clearance::PasswordResetToken.find_user(user.id, token)).to eq user
    end

    it "is nil if the signature is invalid" do
      user = create(:user)

      expect(Clearance::PasswordResetToken.find_user(user.id, "FOO")).to be nil
    end

    it "is nil if the user_id is invalid" do
      user = create(:user)
      token = Clearance::PasswordResetToken.generate_for(user)

      expect(Clearance::PasswordResetToken.find_user(user.id + 1, token)).to be nil
    end

    it "is nil if the signature is valid but expired" do
      user = create(:user)
      token = Clearance::PasswordResetToken.generate_for(user)

      Timecop.freeze(1.day.from_now) do
        expect(Clearance::PasswordResetToken.find_user(user.id, token)).to be nil
      end
    end

    it "is nil if the password changed" do
      user = create(:user, encrypted_password: "something")
      token = Clearance::PasswordResetToken.generate_for(user)
      user.update!(encrypted_password: "something_else")

      expect(Clearance::PasswordResetToken.find_user(user.id, token)).to be nil
    end
  end
end
