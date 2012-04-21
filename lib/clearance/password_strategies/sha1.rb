require 'digest/sha1'

module Clearance
  module PasswordStrategies
    module SHA1
      # Am I authenticated with given password?
      #
      # @param [String] plain-text password
      # @return [true, false]
      # @example
      #   user.authenticated?('password')
      def authenticated?(password)
        encrypted_password == encrypt(password)
      end

      protected

      def encrypt_password
        initialize_salt_if_necessary
        if password.present?
          self.encrypted_password = encrypt(password)
        end
      end

      def generate_hash(string)
        if RUBY_VERSION >= '1.9'
          Digest::SHA1.hexdigest(string).encode('UTF-8')
        else
          Digest::SHA1.hexdigest(string)
        end
      end

      def encrypt(string)
        generate_hash("--#{salt}--#{string}--")
      end

      def initialize_salt_if_necessary
        if salt.blank?
          self.salt = generate_random_code
        end
      end
    end
  end
end
