require 'spec_helper'

module Clearance
  describe SignInGuard do
    it 'handles success' do
      sign_in_guard = SignInGuard.new(double("session"))
      status = double("status")
      allow(SuccessStatus).to receive(:new).and_return(status)

      expect(sign_in_guard.success).to eq(status)
    end

    it 'handles failure' do
      sign_in_guard = SignInGuard.new(double("session"))
      status = double("status")
      failure_message = "Failed"
      allow(FailureStatus).to receive(:new).
        with(failure_message).
        and_return(status)

      expect(sign_in_guard.failure(failure_message)).to eq(status)
    end

    it 'can proceed to the next guard' do
      guards = double("guards", call: true)
      sign_in_guard = SignInGuard.new(double("session"), guards)
      sign_in_guard.next_guard
      expect(guards).to have_received(:call)
    end
  end
end
