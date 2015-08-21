require 'openssl'
require 'base64'

module Clearance
  module PasswordStrategies
    # @deprecated Use {BCrypt} or `clearance-deprecated_password_strategies` gem
    module Blowfish
      DEPRECATION_MESSAGE = "[DEPRECATION] The Blowfish password strategy " \
        "has been deprecated and will be removed from Clearance 2.0. BCrypt " \
        "is the only officially supported strategy, though you are free to " \
        "provide your own. To continue using this strategy add " \
        "clearance-deprecated_password_strategies to your Gemfile."

      def authenticated?(password)
        warn "#{Kernel.caller.first}: #{DEPRECATION_MESSAGE}"
        encrypted_password == encrypt(password)
      end

      def password=(new_password)
        warn "#{Kernel.caller.first}: #{DEPRECATION_MESSAGE}"
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
