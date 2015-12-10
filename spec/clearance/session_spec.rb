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

  describe '#sign_in' do
    it 'sets current_user' do
      user = build(:user, remember_token: 'test-token')

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
end
