module Clearance
  module PasswordStrategies
    # Uses BCrypt to authenticate users and store encrypted passwords.
    #
    # The BCrypt cost (the measure of how many key expansion iterations BCrypt
    # will perform) is automatically set to the minimum allowed value when
    # Rails is operating in the test environment and the default cost in all
    # other envionments. This provides a speed boost in tests.
    #
    # To set your own cost value, use an inititalizer:
    # `BCrypt::Engine.cost = 12`
    module BCrypt
      require 'bcrypt'

      def authenticated?(password)
        if encrypted_password.present?
          ::BCrypt::Password.new(encrypted_password) == password
        end
      end

      def password=(new_password)
        @password = new_password

        if new_password.present?
          self.encrypted_password = ::BCrypt::Password.create(
            new_password,
            cost: cost,
          )
        end
      end

      def cost
        if defined?(::Rails) && ::Rails.env.test?
          ::BCrypt::Engine::MIN_COST
        end
        # Otherwise return nil, so that the cost stored in BCrypt
        # (or its default) is used
      end
    end
  end
end
