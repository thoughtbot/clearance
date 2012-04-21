ENV["RAILS_ENV"] ||= "test"

PROJECT_ROOT = File.expand_path("../..", __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

require 'rails/all'
require 'rails/test_help'

Bundler.require

require 'diesel/testing'
require 'rspec/rails'
require 'bourne'
require 'timecop'
require 'factory_girl_rails'
require 'shoulda-matchers'

require 'clearance/testing'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
end
