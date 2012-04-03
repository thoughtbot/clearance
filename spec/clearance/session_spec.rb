require 'spec_helper'

describe Clearance::Session do
  before { Timecop.freeze }
  after { Timecop.return }

  it "finds a user from a cookie" do
    user = create(:user)
    env = env_with_remember_token(user.remember_token)

    session = Clearance::Session.new(env)
    session.should be_signed_in
    session.current_user.should == user
  end

  it "returns nil for an unknown user" do
    user = create(:user)
    env = env_with_remember_token("bogus")

    session = Clearance::Session.new(env)
    session.should_not be_signed_in
    session.current_user.should be_nil
  end

  it "returns nil without a remember token" do
    env = env_without_remember_token
    session = Clearance::Session.new(env)
    session.should_not be_signed_in
    session.current_user.should be_nil
  end

  it "signs in a given user" do
    user = create(:user)
    session = Clearance::Session.new(env_without_remember_token)
    session.sign_in user
    session.current_user.should == user
  end

  it "sets a remember token cookie with a default expiration of 1 year from now" do
    user = create(:user)
    headers = {}
    session = Clearance::Session.new(env_without_remember_token)
    session.sign_in user
    session.add_cookie_to_headers headers
    headers.should set_cookie("remember_token", user.remember_token, 1.year.from_now)
  end

  it "sets a remember token cookie with a custom expiration" do
    custom_expiration = 1.day.from_now
    with_custom_expiration 1.day.from_now do
      user = create(:user)
      headers = {}
      session = Clearance::Session.new(env_without_remember_token)
      session.sign_in user
      session.add_cookie_to_headers headers
      headers.should set_cookie("remember_token", user.remember_token, 1.day.from_now)
      Clearance.configuration.cookie_expiration.call.should be_within(100).of(1.year.from_now)
    end
  end

  it "doesn't set a remember token when signed out" do
    headers = {}
    session = Clearance::Session.new(env_without_remember_token)
    session.add_cookie_to_headers headers
    headers.should_not set_cookie("remember_token")
  end

  it "signs out a user" do
    user = create(:user)
    old_remember_token = user.remember_token
    env = env_with_remember_token(old_remember_token)

    session = Clearance::Session.new(env)
    session.sign_out
    session.current_user.should be_nil
    user.reload.remember_token.should_not == old_remember_token
  end

  def env_with_remember_token(token)
    env_with_cookies("remember_token" => token)
  end

  def env_without_remember_token
    env_with_cookies({})
  end

  def env_with_cookies(cookies)
    Rack::MockRequest.env_for("/", "HTTP_COOKIE" => serialize_cookies(cookies))
  end

  def serialize_cookies(hash)
    header = {}
    hash.each do |key, value|
      Rack::Utils.set_cookie_header!(header, key, value)
    end
    header['Set-Cookie']
  end

  def with_custom_expiration(custom_duration)
    Clearance.configuration.cookie_expiration = lambda { custom_duration }
  ensure
    restore_default_config
  end

  def restore_default_config
    Clearance.configuration = nil
    Clearance.configure {}
  end
end
