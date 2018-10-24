module Clearance
  module PasswordStrategies
    # Uses BCrypt to authenticate users and store encrypted passwords.
    #
    # The BCrypt cost (the measure of how many key expansion iterations BCrypt
    # will perform) is automatically set to the minimum allowed value when
    # Rails is operating in the test environment and the default cost in all
    # other envionments. This provides a speed boost in tests.
    #
  # BCrypt has a `cost` argument which determines how computationally expensive
  # the hash is to calculate. The higher the cost, the harder it is for
  # attackers to crack passwords even if they posess a database dump of the
  # encrypted passwords. Clearance uses the `bcrypt-ruby` default cost except in 
  # the test environment, where it uses the minimum cost value for speed. If you
  # wish to increase the cost over the default, you can do so by setting a
  # higher cost in an initializer: 
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
