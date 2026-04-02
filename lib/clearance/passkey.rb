module Clearance
  class Passkey < ActiveRecord::Base
    belongs_to :user, class_name: "::User", optional: false

    validates :label, :external_id, :public_key, presence: true
    validates :external_id, uniqueness: true
  end
end
