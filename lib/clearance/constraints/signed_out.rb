module Clearance
  module Constraints
    class SignedOut
      def matches?(request)
        @request = request
        missing_session? || clearance_session.signed_out?
      end

      private

      def clearance_session
        @request.env[:clearance]
      end

      def missing_session?
        clearance_session.nil?
      end
    end
  end
end
