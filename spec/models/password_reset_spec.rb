require "spec_helper"

describe PasswordReset do
  describe ".delete_for" do
    it "deletes password resets for the given user" do
      user = create(:user)
      create_pair(:password_reset, user: user)
      password_reset = create(:password_reset)

      PasswordReset.delete_for(user)

      expect(PasswordReset.all.to_a).to eq [password_reset]
    end
  end
end
