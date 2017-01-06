ENV["RAILS_ENV"] ||= "test"

require "rails/all"
require "dummy/application"

require "clearance/rspec"
require "factory_girl_rails"
require "rspec/rails"
require "shoulda-matchers"
require "timecop"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Dummy::Application.initialize!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
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

  if Rails::VERSION::MAJOR >= 5
    require 'rails-controller-testing'
    config.include Rails::Controller::Testing::TestProcess
    config.include Rails::Controller::Testing::TemplateAssertions
    config.include Rails::Controller::Testing::Integration
  end
end

def restore_default_warning_free_config
  Clearance.configuration = nil
  Clearance.configure { |config| config.rotate_csrf_on_sign_in = true }
end
