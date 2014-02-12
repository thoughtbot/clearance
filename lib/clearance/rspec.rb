require 'rspec/rails'
require 'clearance/testing/deny_access_matcher'
require 'clearance/testing/helpers'

RSpec.configure do |config|
  config.include Clearance::Testing::Matchers, type: :controller
  config.include Clearance::Testing::Helpers, type: :controller
end
