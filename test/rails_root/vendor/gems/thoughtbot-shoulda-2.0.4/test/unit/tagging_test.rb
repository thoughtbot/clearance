require File.dirname(__FILE__) + '/../test_helper'

class TaggingTest < Test::Unit::TestCase
  should_belong_to :post
  should_belong_to :tag
end
