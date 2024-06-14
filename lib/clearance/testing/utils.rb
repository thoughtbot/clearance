module Clearance
  module Testing
    module Utils
      private

      # Creates a user using FactoryBot or FactoryGirl.
      # The factory name is derrived from `user_class` Clearance
      # configuration.
      #
      # @api private
      # @raise [RuntimeError] if FactoryBot or FactoryGirl is not defined.
      def create_user(**factory_options)
        constructor = factory_module("sign_in")

        factory = Clearance.configuration.user_model.to_s.underscore.to_sym
        constructor.create(factory, **factory_options)
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
