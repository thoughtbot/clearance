module Clearance
  # Generate secure token used for password reset tokens.
  class Tokenizer
    # Initialize new tokenizer which will be able to generate
    # and verify token validity for any given user
    def initialize(user)
      # key must be 32 bytes, see: https://github.com/rails/rails/pull/25192
      key_generator = Rails.application.key_generator
      key = key_generator.generate_key(user.encrypted_password, 32)
      @encryptor = ActiveSupport::MessageEncryptor.new(key)
    end

    # Generate secure encrypted token valid for the user
    # @return [String]
    def generate(payload, expires_in: nil)
      encryptor.encrypt_and_sign([payload, expires_in&.from_now])
    end

    # Verify that token are valid for the given user
    # @return [Boo]
    def valid?(token)
      _, expires_at = decrypt(token)

      (expires_at || 1.hour.from_now).future?
    end

    private

    attr_reader :encryptor

    def decrypt(token)
      begin
        encryptor.decrypt_and_verify(token)
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        [nil, 1.hour.ago]
      end
    end
  end
end
