module Clearance
  module Constraints
    class SignedIn
      def initialize(&block)
        @block = block || lambda { |user| true }
      end

      def matches?(request)
        @request = request
        signed_in? && current_user_fulfills_additional_requirements?
      end

      private

      def current_user
        @request.env[:clearance].current_user
      end

      def current_user_fulfills_additional_requirements?
        @block.call current_user
      end

      def signed_in?
        @request.env[:clearance].signed_in?
      end
    end
  end
end
