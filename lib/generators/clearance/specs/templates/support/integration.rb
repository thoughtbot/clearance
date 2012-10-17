RSpec.configure do |config|
  config.include Integration::ClearanceHelpers, :type => :request
  config.include Integration::ActionMailerHelpers, :type => :request
end
