class User < ActiveRecord::Base
  include Clearance::User

  has_many :passkeys, class_name: "Clearance::Passkey", dependent: :destroy
end
