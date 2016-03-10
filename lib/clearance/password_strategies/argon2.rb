module Clearance
  module PasswordStrategies
    module Argon2
      require 'argon2'
      require 'pry'

      def authenticated?(password)
        if encrypted_password.present?
          ::Argon2::Password.verify_password(password, encrypted_password)
        end
      end

      def password=(new_password)
        @password = new_password

        if new_password.present?
          self.encrypted_password = encrypt(new_password)
        end
      end

      private

      # @api private
      def encrypt(password)
        t_cost, m_cost = costs
        argon = ::Argon2::Password.new(t_cost: t_cost, m_cost: m_cost)
        argon.create(password)
      end

      # @api private
      def costs
        test_environment? ? [1, 4] : [2, 16]
      end

      # @api private
      def test_environment?
        defined?(::Rails) && ::Rails.env.test?
      end
    end
  end
end
