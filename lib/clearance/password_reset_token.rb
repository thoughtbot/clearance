module Clearance
  class PasswordResetToken
    def self.generate_for(user)
      token = Clearance.configuration.message_verifier.generate([
        user.id,
        user.encrypted_password,
        Clearance.configuration.password_reset_time_limit.from_now
      ])

      new(token)
    end

    def initialize(token)
      @token = token.to_s
    end

    def user
      user_id, encrypted_password, expires_at = verify

      if expires_at.future?
        Clearance.configuration.user_model.find_by(
          id: user_id,
          encrypted_password: encrypted_password
        )
      end
    end

    def to_s
      token
    end

    private

    attr_reader :token

    def verify
      Clearance.configuration.message_verifier.verify(token)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      [nil, nil, 1.hour.ago]
    end
  end
end
