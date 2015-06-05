require "spec_helper"

describe PasswordReset do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to delegate_method(:user_email).to(:user).as(:email) }

  context "before create" do
    describe "#generate_token" do
      it "generates the token" do
        allow(Clearance::Token).to receive(:new).and_return("abc")

        password_reset = build(:password_reset)
        expect(password_reset.token).to be_nil

        password_reset.save
        expect(password_reset.token).to eq "abc"
      end
    end

    describe "#generate_expires_at" do
      it "generates an expiration timestamp for the reset" do
        allow(Clearance.configuration).to receive(:password_reset_time_limit).
          and_return(10.minutes)

        password_reset = build(:password_reset)
        expect(password_reset.expires_at).to be_nil

        password_reset.save
        expect(password_reset.expires_at).not_to be_nil
      end
    end
  end

  describe ".active_for" do
    it "returns all the unexpired password resets for a user" do
      user = create(:user)
      another_user = create(:user)
      password_reset = create(:password_reset, user: user)
      expired_password_reset = create(:password_reset, user: user)
      expired_password_reset.update_attributes(expires_at: 1.day.ago)
      _another_user_password_reset = create(:password_reset, user: another_user)

      expect(PasswordReset.active_for(user)).to match_array [password_reset]
    end
  end

  describe "#complete" do
    it "updates the password and deactivates all of the user's resets" do
      user = create(:user)
      old_encrypted_password = user.encrypted_password
      password_reset = create(:password_reset, user: user)
      another_password_reset = create(:password_reset, user: user)

      password_reset.complete("password")

      expect(user.reload.encrypted_password).not_to eq old_encrypted_password
      expect(password_reset.reload).to be_expired
      expect(another_password_reset.reload).to be_expired
    end

    context "when the password update fails" do
      it "does not update the password nor expire the reset" do
        user = create(:user)
        old_encrypted_password = user.encrypted_password
        password_reset = create(:password_reset, user: user)

        password_reset.complete("")

        expect(user.reload.encrypted_password).to eq old_encrypted_password
        expect(password_reset.reload).not_to be_expired
      end
    end
  end

  describe "#deactivate" do
    it "sets the password resets expiration to now" do
      password_reset = create(:password_reset)

      password_reset.deactivate

      expect(password_reset.reload).to be_expired
    end
  end

  describe ".time_limit" do
    it "returns the time limit as set in the Clearance configuration" do
      allow(Clearance.configuration).to receive(:password_reset_time_limit).
        and_return(10.minutes)

      expect(PasswordReset.time_limit).to eq 10.minutes
    end
  end

  describe "#expired?" do
    it "returns true if the reset has expired" do
      password_reset = create(:password_reset)
      password_reset.update_attributes(expires_at: 10.minutes.ago)

      expect(password_reset).to be_expired
    end

    it "returns false if the reset has not expired" do
      password_reset = create(:password_reset)
      password_reset.update_attributes(expires_at: 15.minutes.from_now)

      expect(password_reset).not_to be_expired
    end
  end

  describe "#successful?" do
    it "returns true if there are no active password resets" do
      password_reset = create(:password_reset, expires_at: 1.day)

      password_reset.complete("new_password")

      expect(password_reset).to be_successful
    end

    it "returns false if active password resets exists" do
      password_reset = create(:password_reset, expires_at: DateTime.tomorrow)

      expect(password_reset).not_to be_successful
    end
  end
end
