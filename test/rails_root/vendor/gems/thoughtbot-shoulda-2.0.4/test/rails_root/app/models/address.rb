class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  validates_uniqueness_of :title, :scope => [:addressable_type, :addressable_id]
  
  validates_length_of :zip, :minimum => 5
  validates_numericality_of :zip  
end
