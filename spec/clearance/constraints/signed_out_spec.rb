require 'spec_helper'

describe Clearance::Constraints::SignedOut do
  it 'returns true when user is signed out' do
    signed_out_constraint = Clearance::Constraints::SignedOut.new
    signed_out_constraint.matches?(request_without_remember_token).should be_true
  end

  it 'returns false when user is not signed out' do
    user = create(:user)
    signed_out_constraint = Clearance::Constraints::SignedOut.new
    signed_out_constraint.matches?(request_with_remember_token(user.remember_token)).
      should be_false
  end
end
