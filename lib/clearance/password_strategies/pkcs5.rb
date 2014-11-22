module Clearance
  module PasswordStrategies
    module PKCS5
      # Base64.encode64(OpenSSL::PKCS5.pbkdf2_hmac('yeah', OpenSSL::Random.random_bytes(16), 20000, 16, OpenSSL::Digest::SHA256.new))
      require 'openssl'
      require 'base64'

      def authenticated?(password)
        encrypted_password == encrypt(password)
      end

      def password=(new_password)
        if new_password.present?
          self.encrypted_password = encrypt(new_password)
        end
      end

      protected
      def encryption_provider
        OpenSSL::PKCS5
      end

      def encrypt(string)
        initialize_salt_if_neccessary
        salt = Base64.decode64(self.salt)
        cipher = encryption_provider.pbkdf2_hmac_sha1(string, salt, iterations, 16)
        Base64.encode64(cipher).encode('utf-8')
      end

      def initialize_salt_if_neccessary
        self.salt = generate_salt if self.salt.blank?
      end

      def generate_salt
        Base64.encode64(OpenSSL::Random.random_bytes(16)).encode('utf-8')
      end

      def iterations
        if test_environment?
          1
        else
          20_000
        end
      end

      def test_environment?
        defined?(::Rails) && ::Rails.env.test?
      end

    end
  end
end
