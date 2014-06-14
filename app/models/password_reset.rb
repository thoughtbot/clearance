class PasswordReset < ActiveRecord::Base
  belongs_to Clearance.config.user_param_key
  before_create :generate_unique_token
  delegate :email, to: Clearance.config.user_param_key, allow_nil: true

  def self.delete_for(user)
    foreign_key = reflections[Clearance.config.user_param_key].foreign_key
    where(foreign_key => user.id).delete_all
  end

  def to_param
    token
  end

  private

  def generate_unique_token
    self.token = generate_token

    while self.class.exists?(token: self.token)
      self.token = generate_token
    end
  end

  def generate_token
    SecureRandom.hex(20).encode('UTF-8')
  end
end
