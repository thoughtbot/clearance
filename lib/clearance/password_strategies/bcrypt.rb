module Clearance
  module PasswordStrategies
    module BCrypt
      require 'bcrypt'

      extend ActiveSupport::Concern

      def authenticated?(password)
        ::BCrypt::Password.new(encrypted_password) == password
      end

      def password=(new_password)
        @password = new_password

        if new_password.present?
          self.encrypted_password = encrypt(new_password)
        end
      end

      private

      def encrypt(password)
        ::BCrypt::Password.create(password, :cost => cost)
      end

      def cost
        if test_environment?
          ::BCrypt::Engine::MIN_COST
        else
          ::BCrypt::Engine::DEFAULT_COST
        end
      end

      def test_environment?
        defined?(::Rails) && ::Rails.env.test?
      end
    end
  end
end
