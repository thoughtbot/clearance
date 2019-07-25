module Clearance
  class PasswordResetToken
    def self.generate_for(user)
      new(user).generate
    end

    def self.find_user(user_id, token)
      user = Clearance.configuration.user_model.find_by(id: user_id)
      user if user && new(user).valid?(token)
    end

    def initialize(user)
      @user = user
      @tokenizer = Clearance.configuration.tokenizer.new(user)
    end

    def generate
      tokenizer.generate(user.id, expires_in: expires_in)
    end

    def valid?(token)
      tokenizer.valid?(token)
    end

    def to_s
      generate
    end

    private

    attr_reader :user, :tokenizer

    def expires_in
      Clearance.configuration.password_reset_time_limit
    end
  end
end
