class PasswordReset < ActiveRecord::Base
  belongs_to :user, class_name: Clearance.configuration.user_model

  before_create :generate_token, :generate_expiration_timestamp

  private

  def generate_token
    self.token = Clearance::Token.new
  end

  def generate_expiration_timestamp
    self.expires_at = time_limit.from_now
  end

  def time_limit
    Clearance.configuration.password_reset_time_limit
  end
end
