class PasswordReset < ActiveRecord::Base
  before_create :generate_token, :generate_expiration_timestamp

  belongs_to :user, class_name: Clearance.configuration.user_model

  validates :user_id, presence: true

  def self.active_for(user)
    where("user_id = ? AND expires_at > ?", user.id, Time.zone.now)
  end

  def self.deactivate_all
    update_all(expires_at: Time.zone.now)
  end

  def expired?
    expires_at <= Time.zone.now
  end

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
