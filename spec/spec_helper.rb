ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require "rspec/rails"
require "capybara/rspec"
require "factory_girl_rails"
require "pry"

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

  config.before :suite, type: :feature do
    Dir.chdir("spec/dummy") do
      `git init . && git add . && git commit -m "commit"`
      `bundle exec rake db:schema:load`
      `rails g clearance:install`
    end

    Rails.application.reload_routes!
  end

  config.after :suite, type: :feature do
    Dir.chdir("spec/dummy") do
      `git reset --hard && git clean -xfd && rm -rf .git`
    end
  end
end
