require 'spec_helper'

describe Clearance::Constraints::SignedOut do
  it 'returns true when user is signed out' do
    signed_out_constraint = Clearance::Constraints::SignedOut.new
    signed_out_constraint.matches?(request_with_remember_token(nil)).should be_true
  end

  it 'returns false when user is not signed out' do
    user = create(:user, :remember_token => 'abc')

    signed_out_constraint = Clearance::Constraints::SignedOut.new
    signed_out_constraint.matches?(request_with_remember_token(user.remember_token)).should be_false
  end

  def request_with_remember_token(remember_token)
    cookies = {'action_dispatch.cookies' => {
      Clearance::Session::REMEMBER_TOKEN_COOKIE => remember_token
    }}
    env = { :clearance => Clearance::Session.new(cookies) }
    Rack::Request.new(env)
  end
end
