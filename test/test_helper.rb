ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) +
                         "/rails_root/config/environment")
require 'test_help'

$: << File.expand_path(File.dirname(__FILE__) + '/..')
require 'clearance'

gem 'thoughtbot-factory_girl' # from github

require 'factory_girl'
require 'redgreen' rescue LoadError

require File.join(File.dirname(__FILE__), '..', 'shoulda_macros', 'clearance')

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
