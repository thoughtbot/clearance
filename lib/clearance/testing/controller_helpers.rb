module Clearance
  module Testing
    # Provides helpers to your controller specs.
    # These are typically used in tests by requiring `clearance/rspec` or
    # `clearance/test_unit` as appropriate in your `rails_helper.rb` or
    # `test_helper.rb` files.
    module ControllerHelpers
      # @api private
      def setup_controller_request_and_response
        super
        @request.env[:clearance] = Clearance::Session.new(@request.env)
      end

      # Signs in a user that is created using FactoryGirl.
      # The factory name is derrived from your `user_class` Clearance
      # configuration.
      #
      # @raise [RuntimeError] if FactoryGirl is not defined.
      def sign_in
        constructor = factory_module("sign_in")

        factory = Clearance.configuration.user_model.to_s.underscore.to_sym
        sign_in_as constructor.create(factory)
      end

      # Signs in the provided user.
      #
      # @return user
      def sign_in_as(user)
        @request.env[:clearance].sign_in(user)
        user
      end

      # Signs out a user that may be signed in.
      #
      # @return [void]
      def sign_out
        @request.env[:clearance].sign_out
      end

      # Determines the appropriate factory library
      #
      # @api private
      # @raise [RuntimeError] if both FactoryGirl and FactoryBot are not
      #   defined.
      def factory_module(provider)
        if defined?(FactoryBot)
          FactoryBot
        elsif defined?(FactoryGirl)
          FactoryGirl
        else
          raise("Clearance's `#{provider}` helper requires factory_bot")
        end
      end
    end
  end
end
