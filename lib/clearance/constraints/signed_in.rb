module Clearance
  module Constraints
    # Can be applied to make a set of routes visible only to users that are
    # signed in.
    #
    #     # config/routes.rb
    #     constraints Clearance::Constraints::SignedIn.new do
    #       resources :posts
    #     end
    #
    # In the example above, requests to `/posts` from users that are not signed
    # in will result in a 404. You can make additional assertions about the user
    # by passing a block. For instance, if you want to require that the
    # signed-in user be an admin:
    #
    #     # config/routes.rb
    #     constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    #       resources :posts
    #     end
    class SignedIn
      def initialize(&block)
        @block = block || lambda { |user| true }
      end

      def matches?(request)
        @request = request
        signed_in? && current_user_fulfills_additional_requirements?
      end

      private

      def clearance_session
        @request.env[:clearance]
      end

      def current_user
        clearance_session.current_user
      end

      def current_user_fulfills_additional_requirements?
        @block.call current_user
      end

      def signed_in?
        clearance_session.present? && clearance_session.signed_in?
      end
    end
  end
end
