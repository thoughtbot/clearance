require 'spec_helper'

describe Clearance::Constraints::SignedIn do
  it 'returns true when user is signed in' do
    user = create(:user)
    constraint = Clearance::Constraints::SignedIn.new
    request = request_with_remember_token(user.remember_token)
    expect(constraint.matches?(request)).to eq true
  end

  it 'returns false when user is not signed in' do
    constraint = Clearance::Constraints::SignedIn.new
    request = request_without_remember_token
    expect(constraint.matches?(request)).to eq false
  end

  it 'returns false when clearance session data is not present' do
    constraint = Clearance::Constraints::SignedIn.new
    request = Rack::Request.new({})
    expect(constraint.matches?(request)).to eq false
  end

  it 'yields a signed-in user to a provided block' do
    user = create(:user, email: 'before@example.com')

    constraint = Clearance::Constraints::SignedIn.new do |signed_in_user|
      signed_in_user.update_attribute :email, 'after@example.com'
    end

    constraint.matches?(request_with_remember_token(user.remember_token))
    expect(user.reload.email).to eq 'after@example.com'
  end

  it 'does not yield a user if they are not signed in' do
    user = create(:user, email: 'before@example.com')

    constraint = Clearance::Constraints::SignedIn.new do |signed_in_user|
      signed_in_user.update_attribute :email, 'after@example.com'
    end

    constraint.matches?(request_without_remember_token)
    expect(user.reload.email).to eq 'before@example.com'
  end

  it 'matches if the user-provided block returns true' do
    user = create(:user)
    constraint = Clearance::Constraints::SignedIn.new { true }
    request = request_with_remember_token(user.remember_token)
    expect(constraint.matches?(request)).to eq true
  end

  it 'does not match if the user-provided block returns false' do
    user = create(:user)
    constraint = Clearance::Constraints::SignedIn.new { false }
    request = request_with_remember_token(user.remember_token)
    expect(constraint.matches?(request)).to eq false
  end
end
