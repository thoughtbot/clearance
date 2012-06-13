require 'spec_helper'

describe Clearance::Constraints::SignedIn do
  it 'returns true when user is signed in' do
    user = create(:user, :remember_token => 'abc')
    cookies = {'action_dispatch.cookies' => {
      Clearance::Session::REMEMBER_TOKEN_COOKIE => user.remember_token
    }}
    env = { :clearance => Clearance::Session.new(cookies) }
    request = Rack::Request.new(env)

    signed_in_constraint = Clearance::Constraints::SignedIn.new
    signed_in_constraint.matches?(request).should be_true
  end

  it 'returns false when user is not signed in' do
    cookies = {'action_dispatch.cookies' => {}}
    env = { :clearance => Clearance::Session.new(cookies) }
    request = Rack::Request.new(env)

    signed_in_constraint = Clearance::Constraints::SignedIn.new
    signed_in_constraint.matches?(request).should be_false
  end
end
