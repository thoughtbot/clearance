module Clearance
  module PasswordStrategies
    module BCrypt
      require 'bcrypt'

      extend ActiveSupport::Concern

      # Am I authenticated with given password?
      #
      # @param [String] plain-text password
      # @return [true, false]
      # @example
      #   user.authenticated?('password')
      def authenticated?(password)
        decrypted_password == password
      end

      protected

      def encrypt_password
        if password.present?
          self.encrypted_password = ::BCrypt::Password.create(password)
        end
      end

      def decrypted_password
        ::BCrypt::Password.new(encrypted_password)
      end
    end
  end
end
