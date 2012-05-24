require 'clearance/testing/assertion_error'
require 'clearance/testing/deny_access_matcher'
require 'clearance/testing/helpers'

if defined?(ActionController::TestCase)
  ActionController::TestCase.extend Clearance::Testing::Matchers
  class ActionController::TestCase
    include Clearance::Testing::Helpers
  end
end

if defined?(RSpec) && RSpec.respond_to?(:configure)
  RSpec.configure do |config|
    config.include Clearance::Testing::Matchers
    config.include Clearance::Testing::Helpers
  end
end
