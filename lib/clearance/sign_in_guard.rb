require 'clearance/session_status'

module Clearance
  class SignInGuard
    def initialize(session, stack = [])
      @session = session
      @stack = stack
    end

    def success
      SuccessStatus.new
    end

    def failure(message)
      FailureStatus.new(message)
    end

    def next_guard
      stack.call
    end

    private

    attr_reader :stack, :session

    def signed_in?
      session.signed_in?
    end

    def current_user
      session.current_user
    end
  end
end
