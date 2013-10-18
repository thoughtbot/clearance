require 'spec_helper'

module Clearance
  describe SignInGuard do
    it 'handles success' do
      sign_in_guard = SignInGuard.new(stub('session'))
      status = stub('status')
      SuccessStatus.stubs(:new).returns(status)

      expect(sign_in_guard.success).to eq(status)
    end

    it 'handles failure' do
      sign_in_guard = SignInGuard.new(stub('session'))
      status = stub('status')
      failure_message = "Failed"
      FailureStatus.stubs(:new).with(failure_message).returns(status)

      expect(sign_in_guard.failure(failure_message)).to eq(status)
    end

    it 'can proceed to the next guard' do
      guards = stub('guards', call: true)
      sign_in_guard = SignInGuard.new(stub('session'), guards)
      sign_in_guard.next_guard
      expect(guards).to have_received(:call)
    end
  end
end
