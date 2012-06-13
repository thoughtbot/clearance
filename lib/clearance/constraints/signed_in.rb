module Clearance
  module Constraints
    class SignedIn
      def initialize(&block)
        @block = block || lambda { |user| true }
      end

      def matches?(request)
        @request = request
        signed_in? && current_user_matches_block?
      end

      private

      def signed_in?
        @request.env[:clearance].signed_in?
      end

      def current_user_matches_block?
        @block.call(current_user)
      end

      def current_user
        @request.env[:clearance].current_user
      end
    end
  end
end
