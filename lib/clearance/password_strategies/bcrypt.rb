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
        ::BCrypt::Password.create(password)
      end
    end
  end
end
