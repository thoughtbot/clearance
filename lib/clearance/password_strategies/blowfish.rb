require 'openssl'

module Clearance
  module PasswordStrategies
    module Blowfish
      def authenticated?(password)
        encrypted_password == encrypt(password)
      end

      def password=(new_password)
        @password = new_password
        initialize_salt_if_necessary

        if new_password.present?
          self.encrypted_password = encrypt(new_password)
        end
      end

      protected

      def encrypt(string)
        generate_hash("--#{salt}--#{string}--")
      end

      def generate_hash(string)
        cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').encrypt
        cipher.key = Digest::SHA256.digest(salt)
        cipher.update(string) << cipher.final
      end

      def initialize_salt_if_necessary
        if salt.blank?
          self.salt = generate_random_code
        end
      end
    end
  end
end
