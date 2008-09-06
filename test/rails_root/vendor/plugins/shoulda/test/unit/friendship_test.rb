require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < ActiveSupport::TestCase
  should_belong_to :user
  should_belong_to :friend
end
