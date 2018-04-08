require "clearance/testing/deny_access_matcher"
require "clearance/testing/controller_helpers"

ActionDispatch::IntegrationTest.extend Clearance::Testing::Matchers

module Clearance
  module Testing
    module ControllerHelpers
      def sign_in_as(user)
        post session_url, params: { session: { email: user.email, password: user.password } }
        user
      end
    end
  end
end

class ActionDispatch::IntegrationTest
  include Clearance::Testing::ControllerHelpers
end
