class PasswordReset < ActiveRecord::Base
  before_create :generate_token, :generate_expiration_timestamp

  belongs_to :user

  validates :user_id, presence: true

  delegate :email, to: :user, prefix: true

  def self.active_for(user)
    where("user_id = ? AND expires_at > ?", user.id, Time.zone.now)
  end

  def self.time_limit
    Clearance.configuration.password_reset_time_limit
  end

  def deactivate!
    self.expires_at = Time.zone.now
    self.save!
  end

  def expired?
    expires_at <= Time.zone.now
  end

  private

  def generate_token
    self.token = Clearance::Token.new
  end

  def generate_expiration_timestamp
    self.expires_at = self.class.time_limit.from_now
  end
end
