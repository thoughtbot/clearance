require 'spec_helper'

describe Clearance::Constraints::SignedOut do
  it 'returns true when user is signed out' do
    constraint = Clearance::Constraints::SignedOut.new
    request = request_without_remember_token
    expect(constraint.matches?(request)).to eq true
  end

  it 'returns false when user is not signed out' do
    user = create(:user)
    constraint = Clearance::Constraints::SignedOut.new
    request = request_with_remember_token(user.remember_token)
    expect(constraint.matches?(request)).to eq false
  end

  it 'returns true when clearance info is missing from request' do
    constraint = Clearance::Constraints::SignedOut.new
    request = Rack::Request.new({})
    expect(constraint.matches?(request)).to eq true
  end
end
