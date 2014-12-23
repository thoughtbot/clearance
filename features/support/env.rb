ENV["RAILS_ENV"] ||= "test"

require "bundler"
require "rails/all"

require "clearance"
require "aruba/cucumber"
require_relative "../../spec/dummy/application"
require "cucumber/rails/action_controller"
require "cucumber/rails/application"
require "cucumber/rails/capybara"
require "cucumber/rails/database"
require "cucumber/rails/hooks"
require "cucumber/rails/world"

ActionController::Base.allow_rescue = false
Capybara.default_selector = :css
Capybara.save_and_open_page_path = "tmp"
Dummy::Application.initialize!

DatabaseCleaner.strategy = :transaction

Around do |scenario, block|
  Bundler.with_clean_env do
    block.call
  end
end
