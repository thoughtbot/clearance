Dir[Rails.root.join('spec/support/features/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.include Clearance::IntegrationTestHelpers, :type => :feature
end
