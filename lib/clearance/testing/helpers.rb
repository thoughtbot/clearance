module Clearance
  module Testing
    module Helpers
      def setup_controller_request_and_response
        super
        @request.env[:clearance] = Clearance::Session.new(@request.env)
      end

      def sign_in
        sign_in_as FactoryGirl.create(:user)
      end

      def sign_in_as(user)
        @controller.sign_in(user)
      end

      def sign_out
        @controller.sign_out
      end
    end
  end
end
