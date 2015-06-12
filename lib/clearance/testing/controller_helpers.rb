module Clearance
  module Testing
    module ControllerHelpers
      # @private
      def setup_controller_request_and_response
        super
        @request.env[:clearance] = Clearance::Session.new(@request.env)
      end

      # Signs in a user that is created using FactoryGirl.
      # The factory name is derrived from your `user_class` Clearance
      # configuration.
      # @raise [RuntimeError] if FactoryGirl is not defined.
      def sign_in
        unless defined?(FactoryGirl)
          raise("Clearance's `sign_in` helper requires factory_girl")
        end

        factory = Clearance.configuration.user_model.to_s.underscore.to_sym
        sign_in_as FactoryGirl.create(factory)
      end

      # Signs in the provided user.
      def sign_in_as(user)
        @controller.sign_in user
        user
      end

      # Signs out a user that may be signed in.
      def sign_out
        @controller.sign_out
      end
    end
  end
end
