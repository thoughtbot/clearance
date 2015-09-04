module Clearance
  # Indicates a user was successfully signed in, passing all {SignInGuard}s.
  class SuccessStatus
    # Is true, indicating that the sign in was successful.
    def success?
      true
    end
  end

  # Indicates a failure in the {SignInGuard} stack which prevented successful
  # sign in.
  class FailureStatus
    # The reason the sign in failed.
    attr_reader :failure_message

    # @param [String] failure_message The reason the sign in failed.
    def initialize(failure_message)
      @failure_message = failure_message
    end

    # Is false, indicating that the sign in was unsuccessful.
    def success?
      false
    end
  end
end
