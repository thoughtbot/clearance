require "spec_helper"

describe Clearance::DeferredSignInUser do
  context "when an underlying user is present and authenticated" do
    it "is present, not blank and not nil" do
      user = stub_user(authenticated: true, password: "password")
      deferred_sign_in_user = Clearance::DeferredSignInUser.new(
        user,
        "password"
      )

      expect(deferred_sign_in_user).to be_present
      expect(deferred_sign_in_user).to_not be_blank
      expect(deferred_sign_in_user).to_not be_nil
    end
  end

  context "when an underlying user is present and NOT authenticated" do
    it "is not present, is blank and is not nil" do
      user = stub_user(authenticated: false, password: "password")
      deferred_sign_in_user = Clearance::DeferredSignInUser.new(
        user,
        "password"
      )

      expect(deferred_sign_in_user).to_not be_present
      expect(deferred_sign_in_user).to be_blank
      expect(deferred_sign_in_user).to_not be_nil
    end
  end

  describe "when underlying user is nil" do
    it "is not present, is blank and is nil" do
      deferred_sign_in_user = Clearance::DeferredSignInUser.new(nil, "password")

      expect(deferred_sign_in_user).not_to be_present
      expect(deferred_sign_in_user).to be_blank
      expect(deferred_sign_in_user).to be_nil
    end
  end

  it "delegates other method calls to underlying user" do
    user = double("user", first_name: "Foobar")
    deferred_sign_in_user = Clearance::DeferredSignInUser.new(user, "password")

    expect(deferred_sign_in_user.first_name).to eq("Foobar")
  end

  def stub_user(**options)
    double("user").tap do |user|
      allow(user).to receive(:authenticated?).
        with(options[:password]).
        once.
        and_return(options[:authenticated])
    end
  end
end
