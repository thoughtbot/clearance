ENV["RAILS_ENV"] ||= "test"
require_relative "dummy/config/environment"

require "rspec/rails"
require "clearance/rspec"

Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.order = :random
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.before { restore_default_warning_free_config }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :action_controller
    with.library :active_model
    with.library :active_record
  end
end

def restore_default_warning_free_config
  Clearance.configuration = nil
end
