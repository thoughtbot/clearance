require 'spec_helper'

describe Clearance::Session do
  before { Timecop.freeze }
  after { Timecop.return }

  let(:headers) {{}}
  let(:session) { Clearance::Session.new(env_without_remember_token) }
  let(:user) { create(:user) }
  let(:request_domain) { "example.com" }

  it 'finds a user from a cookie' do
    user = create(:user)
    env = env_with_remember_token(user.remember_token)
    session = Clearance::Session.new(env)
    session.should be_signed_in
    session.current_user.should == user
  end

  it 'returns nil for an unknown user' do
    env = env_with_remember_token('bogus')
    session = Clearance::Session.new(env)
    session.should be_signed_out
    session.current_user.should be_nil
  end

  it 'returns nil without a remember token' do
    session.should be_signed_out
    session.current_user.should be_nil
  end

  describe '#sign_in' do
    it 'sets current_user' do
      user = build(:user)

      session.sign_in user

      expect(session.current_user).to eq user
    end

    context 'with nil argument' do
      it 'assigns current_user' do
        session.sign_in nil

        expect(session.current_user).to be_nil
      end
    end
  end

  context 'if httponly is set' do
    before do
      Clearance.configuration.httponly = true
      session.sign_in(user)
    end

    it 'sets a httponly cookie' do
      session.add_cookie_to_headers(headers)

      headers['Set-Cookie'].should =~ /remember_token=.+; HttpOnly/
    end

    after { restore_default_config }
  end

  context 'if httponly is not set' do
    before do
      session.sign_in(user)
    end

    it 'sets a standard cookie' do
      session.add_cookie_to_headers(headers)

      headers['Set-Cookie'].should_not =~ /remember_token=.+; HttpOnly/
    end
  end


  context 'if cookie_domain is set to :all' do
    before do
      Clearance.configuration.cookie_domain = :all
      session.sign_in(user)
    end

    context 'when visiting a top level domain' do
      let(:request_domain){ "example.com" }
      it 'sets a cookie with the top level domain' do
        session.add_cookie_to_headers(headers)
        headers['Set-Cookie'].should =~ /domain=\.example\.com;/
      end
    end

    context 'when visiting a subdomain' do
      let(:request_domain){ "sub.example.com" }
      it 'sets a cookie with the top level domain' do
        session.add_cookie_to_headers(headers)
        headers['Set-Cookie'].should =~ /domain=\.example\.com;/
      end
    end

    after {restore_default_config}

  end

  context 'if cookie_domain is not set' do
      let(:request_domain){ "sub.example.com" }
      it 'sets a cookie with the current domain' do
        session.add_cookie_to_headers(headers)
        headers['Set-Cookie'].should =~ /domain=\.sub\.example\.com;/
      end
  end

  context 'if cookie_domain is set to ".example.com"' do
    before do
      Clearance.configuration.cookie_domain = ".example.com"
    end

    let(:request_domain){ "otherdomain.com" }
    it 'sets the domain to ".example.com"' do
      session.add_cookie_to_headers(headers)
      headers['Set-Cookie'].should =~ /domain=\.example\.com;/
    end

    after {restore_default_config}

  end

  it 'sets a remember token cookie with a default expiration of 1 year from now' do
    user = create(:user)
    headers = {}
    session = Clearance::Session.new(env_without_remember_token)
    session.sign_in user
    session.add_cookie_to_headers headers
    headers.should set_cookie('remember_token', user.remember_token, 1.year.from_now)
  end

  it 'sets a remember token cookie with a custom expiration' do
    with_custom_expiration 1.day.from_now do
      user = create(:user)
      headers = {}
      session = Clearance::Session.new(env_without_remember_token)
      session.sign_in user
      session.add_cookie_to_headers headers
      headers.should set_cookie('remember_token', user.remember_token, 1.day.from_now)
      Clearance.configuration.cookie_expiration.call.should be_within(100).
        of(1.year.from_now)
    end
  end

  context 'if secure_cookie is set' do
    before do
      Clearance.configuration.secure_cookie = true
      session.sign_in(user)
    end

    it 'sets a secure cookie' do
      session.add_cookie_to_headers(headers)

      headers['Set-Cookie'].should =~ /remember_token=.+; secure/
    end

    after { restore_default_config }
  end

  context 'if secure_cookie is not set' do
    before do
      session.sign_in(user)
    end

    it 'sets a standard cookie' do
      session.add_cookie_to_headers(headers)

      headers['Set-Cookie'].should_not =~ /remember_token=.+; secure/
    end
  end

  it 'does not set a remember token when signed out' do
    headers = {}
    session = Clearance::Session.new(env_without_remember_token)
    session.add_cookie_to_headers headers
    headers.should_not set_cookie('remember_token')
  end

  it 'signs out a user' do
    user = create(:user)
    old_remember_token = user.remember_token
    env = env_with_remember_token(old_remember_token)
    session = Clearance::Session.new(env)
    session.sign_out
    session.current_user.should be_nil
    user.reload.remember_token.should_not == old_remember_token
  end

  def env_with_cookies(cookies)
    Rack::MockRequest.env_for "http://#{request_domain}/", 'HTTP_COOKIE' => serialize_cookies(cookies)
  end

  def env_with_remember_token(token)
    env_with_cookies 'remember_token' => token
  end

  def env_without_remember_token
    env_with_cookies({})
  end

  def serialize_cookies(hash)
    header = {}

    hash.each do |key, value|
      Rack::Utils.set_cookie_header! header, key, value
    end

    header['Set-Cookie']
  end

  def with_custom_expiration(custom_duration)
    Clearance.configuration.cookie_expiration = lambda { custom_duration }
  ensure
    restore_default_config
  end
end
