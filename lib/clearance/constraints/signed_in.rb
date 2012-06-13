module Clearance
  module Constraints
    class SignedIn
      def matches?(request)
        request.env[:clearance].signed_in?
      end
    end
  end
end
