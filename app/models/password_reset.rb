class PasswordReset < ActiveRecord::Base
  before_create :generate_token, :generate_expiration_timestamp

  belongs_to :user

  validates :user_id, presence: true

  delegate :email, to: :user, prefix: true

  def self.active_for(user_id)
    where("#{Clearance.configuration.user_id_parameter} = ? AND expires_at > ?", user_id, Time.zone.now)
  end

  def self.time_limit
    Clearance.configuration.password_reset_time_limit
  end

  def complete(new_password)
    reset_successful = false

    transaction do
      unless user.update_password(new_password)
        raise ActiveRecord::Rollback
      end

      deactivate_user_resets
      reset_successful = true
    end

    reset_successful
  end

  def deactivate
    update_attributes(expires_at: Time.zone.now)
  end

  def expired?
    expires_at <= Time.zone.now
  end

  private

  def active?
    !expired?
  end

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
