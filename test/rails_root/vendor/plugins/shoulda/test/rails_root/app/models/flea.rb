class Flea < ActiveRecord::Base
  has_and_belongs_to_many :dogs
end
