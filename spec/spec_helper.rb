ENV['RAILS_ENV'] ||= 'test'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'rails/all'
require 'rails/test_help'

Bundler.require

require 'clearance/testing/application'
require 'rspec/rails'
require 'bourne'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'clearance/testing'
require 'timecop'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Clearance::Testing::Application.initialize!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :mocha
  config.use_transactional_fixtures = true
end

def restore_default_config
  Clearance.configuration = nil
  Clearance.configure {}
end
