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
        @controller.current_user = user
      end

      def sign_out
        @controller.current_user = nil
      end
    end
  end
end
