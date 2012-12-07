Dir[Rails.root.join("spec/support/integration/*.rb")].sort.each {|f| require f}

RSpec.configure do |config|
  config.include Integration::ClearanceHelpers, :type => :request
  config.include Integration::ActionMailerHelpers, :type => :request
end
