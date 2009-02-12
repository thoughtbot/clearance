ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

# Run the migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")

gem 'thoughtbot-factory_girl' # from github

require 'factory_girl'
require 'quietbacktrace'
require 'redgreen'

require File.join(File.dirname(__FILE__), '..', '..', '..', 'shoulda_macros', 'clearance')

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
