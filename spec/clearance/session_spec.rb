require 'spec_helper'

describe Clearance::Session do
  before { Timecop.freeze }
  after { Timecop.return }

  let(:headers) { {} }
  let(:session) { Clearance::Session.new(env_without_remember_token) }
  let(:user) { create(:user) }

  it 'finds a user from a cookie' do
    user = create(:user)
    env = env_with_remember_token(user.remember_token)
    session = Clearance::Session.new(env)

    expect(session).to be_signed_in
    expect(session.current_user).to eq user
  end

  it 'returns nil for an unknown user' do
    env = env_with_remember_token('bogus')
    session = Clearance::Session.new(env)

    expect(session).to be_signed_out
    expect(session.current_user).to be_nil
  end

  it 'returns nil without a remember token' do
    expect(session).to be_signed_out
    expect(session.current_user).to be_nil
  end

  context "with a custom cookie name" do
    it "sets a custom cookie name in the header" do
      Clearance.configuration.cookie_domain = "custom_token"

      session.sign_in user
      session.add_cookie_to_headers(headers)

      expect(headers["Set-Cookie"]).to match(/custom_token/)
    end

    after { restore_default_config }
  end

  describe '#sign_in' do
    it 'sets current_user' do
      user = build(:user)

      session.sign_in user

      expect(session.current_user).to eq user
    end

    context 'with a block' do
      it 'passes the success status to the block when sign in succeeds' do
        success_status = stub_status(Clearance::SuccessStatus, true)
        success_lambda = stub_callable

        session.sign_in build(:user), &success_lambda

        expect(success_lambda).to have_been_called.with(success_status)
      end

      it 'passes the failure status to the block when sign in fails' do
        failure_status = stub_status(Clearance::FailureStatus, false)
        failure_lambda = stub_callable

        session.sign_in nil, &failure_lambda

        expect(failure_lambda).to have_been_called.with(failure_status)
      end

      def stub_status(status_class, success)
        double("status", success?: success).tap do |status|
          allow(status_class).to receive(:new).and_return(status)
        end
      end

      def stub_callable
        lambda {}.tap do |callable|
          allow(callable).to receive(:call)
        end
      end
    end

    context 'with nil argument' do
      it 'assigns current_user' do
        session.sign_in nil

        expect(session.current_user).to be_nil
      end
    end

    context 'with a sign in stack' do

      it 'runs the first guard' do
        guard = stub_sign_in_guard(succeed: true)
        user = build(:user)

        session.sign_in user

        expect(guard).to have_received(:call)
      end

      it 'will not sign in the user if the guard stack fails' do
        stub_sign_in_guard(succeed: false)
        user = build(:user)

        session.sign_in user

        expect(session.instance_variable_get("@cookies")).to be_nil
        expect(session.current_user).to be_nil
      end


      def stub_sign_in_guard(options)
        session_status = stub_status(options.fetch(:succeed))

        double("guard", call: session_status).tap do |guard|
          Clearance.configuration.sign_in_guards << stub_guard_class(guard)
        end
      end

      def stub_default_sign_in_guard
        double("default_sign_in_guard").tap do |sign_in_guard|
          allow(Clearance::DefaultSignInGuard).to receive(:new).
            with(session).
            and_return(sign_in_guard)
        end
      end

      def stub_guard_class(guard)
        double("guard_class").tap do |guard_class|
          allow(guard_class).to receive(:new).
            with(session, stub_default_sign_in_guard).
            and_return(guard)
        end
      end

      def stub_status(success)
        double("status", success?: success)
      end

      after do
        Clearance.configuration.sign_in_guards = []
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

      expect(headers['Set-Cookie']).to match(/remember_token=.+; HttpOnly/)
    end

    after { restore_default_config }
  end

  context 'if httponly is not set' do
    before do
      session.sign_in(user)
    end

    it 'sets a standard cookie' do
      session.add_cookie_to_headers(headers)

      expect(headers['Set-Cookie']).not_to match(/remember_token=.+; HttpOnly/)
    end
  end

  describe 'remember token cookie expiration' do
    context 'default configuration' do
      it 'is set to 1 year from now' do
        user = double("User", remember_token: "123abc")
        headers = {}
        session = Clearance::Session.new(env_without_remember_token)
        session.sign_in user
        session.add_cookie_to_headers headers

        expect(headers).to set_cookie(
          'remember_token',
          user.remember_token, 1.year.from_now
        )
      end
    end

    context 'configured with lambda taking no arguments' do
      it 'logs a deprecation warning' do
        expiration = -> { Time.now }
        with_custom_expiration expiration do
          session = Clearance::Session.new(env_without_remember_token)
          allow(session).to receive(:warn)
          session.add_cookie_to_headers headers

          expect(session).to have_received(:warn).once
        end
      end

      it 'is set to the value of the evaluated lambda' do
        expires_at = -> { 1.day.from_now }
        with_custom_expiration expires_at do
          user = double("User", remember_token: "123abc")
          headers = {}
          session = Clearance::Session.new(env_without_remember_token)
          session.sign_in user
          allow(session).to receive(:warn)
          session.add_cookie_to_headers headers

          expect(headers).to set_cookie(
            'remember_token',
            user.remember_token, expires_at.call
          )
        end
      end
    end

    context 'configured with lambda taking one argument' do
      it 'it can use other cookies to set the value of the expires token' do
        remembered_expires = 12.hours.from_now
        expires_at = ->(cookies) do
          cookies['remember_me'] ? remembered_expires : nil
        end
        with_custom_expiration expires_at do
          user = double("User", remember_token: "123abc")
          headers = {}
          environment = env_with_cookies(remember_me: 'true')
          session = Clearance::Session.new(environment)
          session.sign_in user
          session.add_cookie_to_headers headers

          expect(headers).to set_cookie(
            'remember_token',
            user.remember_token,
            remembered_expires
          )

        end
      end
    end
  end

  describe 'secure cookie option' do
    context 'when not set' do
      before do
        session.sign_in(user)
      end

      it 'sets a standard cookie' do
        session.add_cookie_to_headers(headers)

        expect(headers['Set-Cookie']).not_to match(/remember_token=.+; secure/)
      end
    end

    context 'when set' do
      before do
        Clearance.configuration.secure_cookie = true
        session.sign_in(user)
      end

      it 'sets a secure cookie' do
        session.add_cookie_to_headers(headers)

        expect(headers['Set-Cookie']).to match(/remember_token=.+; secure/)
      end

      after { restore_default_config }
    end
  end

  describe 'cookie domain option' do
    context 'when set' do
      before do
        Clearance.configuration.cookie_domain = '.example.com'
        session.sign_in(user)
      end

      it 'sets a standard cookie' do
        session.add_cookie_to_headers(headers)

        expect(headers['Set-Cookie']).to match(/domain=\.example\.com; path/)
      end

      after { restore_default_config }
    end

    context 'when not set' do
      before { session.sign_in(user) }

      it 'sets a standard cookie' do
        session.add_cookie_to_headers(headers)

        expect(headers['Set-Cookie']).not_to match(/domain=.+; path/)
      end
    end
  end

  describe 'cookie path option' do
    context 'when not set' do
      before { session.sign_in(user) }

      it 'sets a standard cookie' do
        session.add_cookie_to_headers(headers)

        expect(headers['Set-Cookie']).to_not match(/domain=.+; path/)
      end
    end

    context 'when set' do
      before do
        Clearance.configuration.cookie_path = '/user'
        session.sign_in(user)
      end

      it 'sets a standard cookie' do
        session.add_cookie_to_headers(headers)

        expect(headers['Set-Cookie']).to match(/path=\/user; expires/)
      end

      after { restore_default_config }
    end
  end

  it 'does not set a remember token when signed out' do
    headers = {}
    session = Clearance::Session.new(env_without_remember_token)
    session.add_cookie_to_headers headers
    expect(headers["Set-Cookie"]).to be nil
  end

  it 'signs out a user' do
    user = create(:user)
    old_remember_token = user.remember_token
    env = env_with_remember_token(old_remember_token)
    session = Clearance::Session.new(env)
    session.sign_out
    expect(session.current_user).to be_nil
    expect(user.reload.remember_token).not_to eq old_remember_token
  end

  def env_with_cookies(cookies)
    Rack::MockRequest.env_for '/', 'HTTP_COOKIE' => serialize_cookies(cookies)
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

  def have_been_called
    have_received(:call)
  end

  def with_custom_expiration(custom_duration)
    Clearance.configuration.cookie_expiration = custom_duration
    yield
  ensure
    restore_default_config
  end
end
