require "rspec/rails"
require "clearance/testing/deny_access_matcher"
require "clearance/testing/controller_helpers"
require "clearance/testing/view_helpers"

RSpec.configure do |config|
  config.include Clearance::Testing::Matchers, type: :controller
  config.include Clearance::Testing::ControllerHelpers, type: :controller
  config.include Clearance::Testing::ViewHelpers, type: :view
  config.include Clearance::Testing::ViewHelpers, type: :helper

  config.before(:each, type: :view) do
    view.extend Clearance::Testing::ViewHelpers::CurrentUser
  end

  config.before(:each, type: :helper) do
    view.extend Clearance::Testing::ViewHelpers::CurrentUser
  end
end
