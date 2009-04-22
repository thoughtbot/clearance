# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'factory_girl'
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures
Cucumber::Rails.bypass_rescue

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end
