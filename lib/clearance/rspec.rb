require 'rspec/rails'
require 'clearance/testing/assertion_error'
require 'clearance/testing/deny_access_matcher'
require 'clearance/testing/helpers'

RSpec.configure do |config|
  config.include Clearance::Testing::Matchers
  config.include Clearance::Testing::Helpers, :type => :controller
end
