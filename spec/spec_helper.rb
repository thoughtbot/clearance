ENV['RAILS_ENV'] ||= 'test'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'rails/all'
require 'rails/test_help'

Bundler.require

require 'clearance/testing/application'
require 'rspec/rails'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'clearance/rspec'
require 'timecop'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Clearance::Testing::Application.initialize!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end
end

def restore_default_config
  Clearance.configuration = nil
  Clearance.configure {}
end
