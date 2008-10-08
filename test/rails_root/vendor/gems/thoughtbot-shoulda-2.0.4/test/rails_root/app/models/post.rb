class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, :foreign_key => :user_id, :class_name => 'User'
  has_many :taggings
  has_many :tags, :through => :taggings
  has_many :through_tags, :through => :taggings, :source => :tag

  validates_uniqueness_of :title
  validates_presence_of :title
  validates_presence_of :body, :message => 'Seriously...  wtf'
  validates_numericality_of :user_id
end
