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

  def complete(new_password)
    transaction do
      unless user.update_password(new_password)
        raise ActiveRecord::Rollback
      end

      deactivate_user_resets
    end
  end

  def deactivate
    update_attributes(expires_at: Time.zone.now)
  end

  def expired?
    expires_at <= Time.zone.now
  end

  def successful?
    !self.class.active_for(user).exists?
  end

  private

  def deactivate_user_resets
    Clearance::PasswordResetsDeactivator.new(user).run
  end

  def generate_token
    self.token = Clearance::Token.new
  end

  def generate_expiration_timestamp
    self.expires_at = self.class.time_limit.from_now
  end
end
