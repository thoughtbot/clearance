require 'spec_helper'

describe Clearance::DefaultSignInGuard do
  context 'session is signed in' do
    it 'returns success' do
      session = double("Session", signed_in?: true)
      guard = Clearance::DefaultSignInGuard.new(session)

      expect(guard.call).to be_a Clearance::SuccessStatus
    end
  end

  context 'session is not signed in' do
    it 'returns failure' do
      session = double("Session", signed_in?: false)
      guard = Clearance::DefaultSignInGuard.new(session)

      response = guard.call

      expect(response).to be_a Clearance::FailureStatus
      expect(response.failure_message).to eq default_failure_message
    end
  end

  def default_failure_message
    I18n.t('flashes.failure_after_create').html_safe
  end
end
