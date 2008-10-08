class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :posts, :through => :taggings
  
  validates_length_of :name, :minimum => 2

  attr_accessible :name
end
