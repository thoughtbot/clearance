module Clearance
  module Constraints
    class SignedOut
      def matches?(request)
        request.env[:clearance].signed_out?
      end
    end
  end
end
