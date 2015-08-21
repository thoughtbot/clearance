module Clearance
  module Constraints
    # Can be applied to make a set of routes visible only to users that are
    # signed out.
    #
    #     # config/routes.rb
    #     constraints Clearance::Constraints::SignedOut.new do
    #       resources :registrations, only: [:new, :create]
    #     end
    #
    # In the example above, requests to `/registrations/new` from users that are
    # signed in will result in a 404.
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
