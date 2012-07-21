module Clearance
  module PasswordStrategies
    module Fake
      extend ActiveSupport::Concern

      def authenticated?(password)
        encrypted_password == password
      end

      def encrypt(password)
        password
      end

      def password=(new_password)
        @password = new_password

        if new_password.present?
          self.encrypted_password = encrypt(password)
        end
      end
    end
  end
end
