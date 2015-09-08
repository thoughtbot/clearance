require "spec_helper"

describe Clearance::PasswordResetsDeactivator do
  describe ".run" do
    it "invalidates all active password resets for the user" do
      user = create(:user)
      password_reset = create(:password_reset, user: user)
      password_reset_deactivator = Clearance::PasswordResetsDeactivator.new(user)

      expect(password_reset).not_to be_expired

      password_reset_deactivator.run

      expect(password_reset.reload).to be_expired
    end
  end
end
