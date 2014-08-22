require 'spec_helper'

describe Clearance::Constraints::SignedOut do
  it 'returns true when user is signed out' do
    signed_out_constraint = Clearance::Constraints::SignedOut.new
    no_idea_what_to_call_this = signed_out_constraint.matches?(request_without_remember_token)
    expect(no_idea_what_to_call_this).to be_truthy
  end

  it 'returns false when user is not signed out' do
    user = create(:user)
    signed_out_constraint = Clearance::Constraints::SignedOut.new
    request = request_with_remember_token(user.remember_token)
    expect(signed_out_constraint.matches? (request)).to be_falsey
  end
end
