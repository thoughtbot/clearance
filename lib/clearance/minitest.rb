require 'test/unit'
require 'clearance/testing/assertion_error'
require 'clearance/testing/deny_access_matcher'
require 'clearance/testing/helpers'

ActionController::TestCase.extend Clearance::Testing::Matchers

class ActionController::TestCase
  include Clearance::Testing::Helpers
end
