class Dog < ActiveRecord::Base
  belongs_to :user, :foreign_key => :owner_id
  belongs_to :address
  has_and_belongs_to_many :fleas
end
