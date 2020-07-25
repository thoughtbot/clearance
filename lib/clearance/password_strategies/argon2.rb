module Clearance
  module PasswordStrategies
    # Uses Argon2 to authenticate users and store encrypted passwords.

    module Argon2
      require "argon2"

      def authenticated?(password)
        if encrypted_password.present?
          ::Argon2::Password.verify_password(password, encrypted_password)
        end
      end

      def password=(new_password)
        @password = new_password

        if new_password.present?
          self.encrypted_password = ::Argon2::Password.new.create(new_password)
        end
      end
    end
  end
end
