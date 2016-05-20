require "spec_helper"

describe Clearance::PasswordResetToken do
  describe ".generate_for" do
    it "uses the configured message verifier to generate a token" do
      Timecop.freeze do
        user = double("User", id: 1, encrypted_password: "foo")
        time_limit = Clearance.configuration.password_reset_time_limit
        allow(Clearance.configuration.message_verifier).to receive(:generate).
          with([1, "foo", time_limit.from_now]).
          and_return("SEKRET")

        token = Clearance::PasswordResetToken.generate_for(user)

        expect(token.to_s).to eq "SEKRET"
      end
    end
  end

  describe "#user" do
    it "is the user if signature is valid and token is not expired" do
      user = create(:user)
      token = Clearance::PasswordResetToken.generate_for(user)

      expect(token.user).to eq user
    end

    it "is nil if the signature is invalid" do
      token = Clearance::PasswordResetToken.new("FOO")

      expect(token.user).to be nil
    end

    it "is nil if the signature is valid but expired" do
      user = double("User", id: 1, encrypted_password: "foo")
      token = Clearance::PasswordResetToken.generate_for(user)

      Timecop.freeze(1.day.from_now) do
        expect(token.user).to be nil
      end
    end

    it "is nil if the signature is valid an unexpired by password changed" do
      user = create(:user, encrypted_password: "something")
      token = Clearance::PasswordResetToken.generate_for(user)
      user.update!(encrypted_password: "something_else")

      expect(token.user).to be nil
    end
  end
end
