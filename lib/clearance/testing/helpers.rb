module Clearance
  module Testing
    module Helpers
      def setup_controller_request_and_response
        super
        @request.env[:clearance] = Clearance::Session.new(@request.env)
      end

      def sign_in
        unless defined?(FactoryGirl)
          raise(
            RuntimeError,
            "Clearance's `sign_in` helper requires factory_girl"
          )
        end

        factory = Clearance.configuration.user_model.to_s.underscore.to_sym
        sign_in_as FactoryGirl.create(factory)
      end

      def sign_in_as(user)
        @controller.sign_in user
        user
      end

      def sign_out
        @controller.sign_out
      end
    end
  end
end
