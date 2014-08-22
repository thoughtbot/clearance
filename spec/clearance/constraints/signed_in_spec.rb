require 'spec_helper'

describe Clearance::Constraints::SignedIn do
  it 'returns true when user is signed in' do
    user = create(:user)
    signed_in_constraint = Clearance::Constraints::SignedIn.new
    expect(signed_in_constraint.matches?\
           (request_with_remember_token(user.remember_token))).to be_truthy
  end

  it 'returns false when user is not signed in' do
    signed_in_constraint = Clearance::Constraints::SignedIn.new
    expect(signed_in_constraint.matches?\
           (request_without_remember_token)).to be_falsey
  end

  it 'yields a signed-in user to a provided block' do
    user = create(:user, email: 'before@example.com')

    signed_in_constraint = Clearance::Constraints::SignedIn.new do |user|
      user.update_attribute :email, 'after@example.com'
    end

    signed_in_constraint.matches?\
            (request_with_remember_token(user.remember_token))
    expect(user.reload.email).to eq 'after@example.com'
  end

  it 'does not yield a user if they are not signed in' do
    user = create(:user, email: 'before@example.com')

    signed_in_constraint = Clearance::Constraints::SignedIn.new do |user|
      user.update_attribute :email, 'after@example.com'
    end

    signed_in_constraint.matches?(request_without_remember_token)
    expect(user.reload.email).to eq 'before@example.com'
  end

  it 'matches if the user-provided block returns true' do
    user = create(:user)
    signed_in_constraint = Clearance::Constraints::SignedIn.new { |user| true }
    expect(signed_in_constraint.matches?\
           (request_with_remember_token(user.remember_token))).to be_truthy
  end

  it 'does not match if the user-provided block returns false' do
    user = create(:user)
    signed_in_constraint = Clearance::Constraints::SignedIn.new { |user| false }
    expect(signed_in_constraint.matches?\
           (request_with_remember_token(user.remember_token))).to be_falsey
  end
end
