require 'test_helper'

class ClearanceMailerTest < ActionMailer::TestCase
  tests ClearanceMailer
  include Clearance::Test::Unit::ClearanceMailerTest
end
