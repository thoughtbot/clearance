module Clearance
  module PasswordStrategies
    # @deprecated Use {BCrypt} or `clearance-deprecated_password_strategies` gem
    module SHA1
      require 'digest/sha1'

      DEPRECATION_MESSAGE = "[DEPRECATION] The SHA1 password strategy " \
        "has been deprecated and will be removed from Clearance 2.0. BCrypt " \
        "is the only officially supported strategy, though you are free to " \
        "provide your own. To continue using this strategy add " \
        "clearance-deprecated_password_strategies to your Gemfile."

      extend ActiveSupport::Concern

      # @deprecated Use {BCrypt} or `clearance-deprecated_password_strategies`
      #   gem
      def authenticated?(password)
        warn "#{Kernel.caller.first}: #{DEPRECATION_MESSAGE}"
        encrypted_password == encrypt(password)
      end

      # @deprecated Use {BCrypt} or `clearance-deprecated_password_strategies`
      #   gem
      def password=(new_password)
        warn "#{Kernel.caller.first}: #{DEPRECATION_MESSAGE}"
        @password = new_password
        initialize_salt_if_necessary

        if new_password.present?
          self.encrypted_password = encrypt(new_password)
        end
      end

      private

      # @api private
      def encrypt(string)
        generate_hash "--#{salt}--#{string}--"
      end

      # @api private
      def generate_hash(string)
        Digest::SHA1.hexdigest(string).encode 'UTF-8'
      end

      # @api private
      def initialize_salt_if_necessary
        if salt.blank?
          self.salt = generate_salt
        end
      end

      # @api private
      def generate_salt
        SecureRandom.hex(20).encode('UTF-8')
      end
    end
  end
end
