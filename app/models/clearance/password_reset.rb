class Clearance::PasswordReset < ActiveRecord::Base
  belongs_to :user
  before_create :generate_unique_token
  delegate :email, to: :user, allow_nil: true

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
