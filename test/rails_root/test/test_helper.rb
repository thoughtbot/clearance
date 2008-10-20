ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

# Run the migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")

gem 'mocha'
gem 'thoughtbot-factory_girl' # from github

require 'mocha'
require 'factory_girl'
require File.expand_path(File.dirname(__FILE__)) + '/factories'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  include Clearance::Test::TestHelper
end
