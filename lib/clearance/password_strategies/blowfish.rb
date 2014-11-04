require 'openssl'
require 'base64'

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
        hash = cipher.update(string) << cipher.final
        Base64.encode64(hash).encode('utf-8')
      end

      def initialize_salt_if_necessary
        if salt.blank?
          self.salt = generate_salt
        end
      end

      def generate_salt
        Base64.encode64(SecureRandom.hex(20)).encode('utf-8')
      end
    end
  end
end
