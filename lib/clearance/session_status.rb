module Clearance
  class SuccessStatus
    def success?
      true
    end
  end

  class FailureStatus
    attr_reader :failure_message

    def initialize(failure_message)
      @failure_message = failure_message
    end

    def success?
      false
    end
  end
end
