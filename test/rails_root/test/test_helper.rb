ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

# Run the migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")

gem 'mocha'
gem 'thoughtbot-quietbacktrace'
gem 'thoughtbot-factory_girl' # from github

require 'mocha'
require 'quietbacktrace'
require 'factory_girl'

class Test::Unit::TestCase
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  self.backtrace_silencers << :rails_vendor
  self.backtrace_filters   << :rails_root
  
  include Clearance::TestHelper
  
end
