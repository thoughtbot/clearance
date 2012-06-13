module Clearance
  module Constraints
    class SignedIn
      def initialize(&block)
        @block = block
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
        if @block
          @block.call(current_user)
        else
          true
        end
      end

      def current_user
        @request.env[:clearance].current_user
      end
    end
  end
end
