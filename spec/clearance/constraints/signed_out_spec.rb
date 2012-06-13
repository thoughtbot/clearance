require 'spec_helper'

describe Clearance::Constraints::SignedOut do
  it 'returns true when user is signed out' do
    user = create(:user, :remember_token => 'abc')
    cookies = {'action_dispatch.cookies' => {
      Clearance::Session::REMEMBER_TOKEN_COOKIE => user.remember_token
    }}
    env = { :clearance => Clearance::Session.new(cookies) }
    request = Rack::Request.new(env)

    signed_in_constraint = Clearance::Constraints::SignedOut.new
    signed_in_constraint.matches?(request).should be_false
  end

  it 'returns false when user is not signed out' do
    cookies = {'action_dispatch.cookies' => {}}
    env = { :clearance => Clearance::Session.new(cookies) }
    request = Rack::Request.new(env)

    signed_in_constraint = Clearance::Constraints::SignedOut.new
    signed_in_constraint.matches?(request).should be_true
  end
end
