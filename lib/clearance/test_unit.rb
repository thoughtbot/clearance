require "clearance/testing/deny_access_matcher"
require "clearance/testing/controller_helpers"

ActionController::TestCase.extend Clearance::Testing::Matchers

class ActionController::TestCase
  include Clearance::Testing::ControllerHelpers
end
