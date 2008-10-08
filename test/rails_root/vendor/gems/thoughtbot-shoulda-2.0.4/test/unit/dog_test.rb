require File.dirname(__FILE__) + '/../test_helper'

class DogTest < Test::Unit::TestCase
  should_belong_to :user
  should_belong_to :address
  should_have_and_belong_to_many :fleas
end
