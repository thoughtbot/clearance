ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "factory_girl_rails"
require "pry"

require "support/email_spec"
require "support/dummy_app_setup"

Monban.test_mode!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
