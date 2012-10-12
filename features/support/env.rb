ENV['RAILS_ENV'] ||= 'test'

PROJECT_ROOT = File.expand_path('../../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require 'rails/all'
require 'rails/test_help'

Bundler.require

require 'aruba/cucumber'
require 'clearance/testing/application'
require 'cucumber/rails/action_controller'
require 'cucumber/rails/application'
require 'cucumber/rails/capybara'
require 'cucumber/rails/hooks'
require 'cucumber/rails/world'

ActionController::Base.allow_rescue = false
Capybara.default_selector = :css
Capybara.save_and_open_page_path = 'tmp'
Clearance::Testing::Application.initialize!

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end
