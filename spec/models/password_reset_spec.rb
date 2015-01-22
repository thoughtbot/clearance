require "spec_helper"

describe PasswordReset do
  context "before create" do
    describe "#generate_token" do
      it "generates the token" do
        user = build_stubbed(:user)
        allow(Clearance::Token).to receive(:new).and_return("abc")

        password_reset = build(:password_reset, user: user)
        expect(password_reset.token).to be_nil

        password_reset.save
        expect(password_reset.token).to eq "abc"
      end
    end

    describe "#generate_expires_at" do
      it "generates an expiration timestamp for the reset" do
        user = build_stubbed(:user)
        allow(Clearance.configuration).to receive(:password_reset_time_limit).
          and_return(10.minutes)

        password_reset = build(:password_reset, user: user)
        expect(password_reset.expires_at).to be_nil

        password_reset.save
        expect(Clearance.configuration).
          to have_received(:password_reset_time_limit)
        expect(password_reset.expires_at).not_to be_nil
      end
    end
  end
end
