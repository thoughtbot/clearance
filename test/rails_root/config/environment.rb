PROJECT_NAME = "clearance"
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')
require 'md5' # Need this up here to generate the session[:secret] value down there

Rails::Initializer.run do |config|
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  config.time_zone = 'Eastern Time (US & Canada)'
  config.action_controller.session = {
    :session_key => "_#{PROJECT_NAME}_session",
    :secret      => [PROJECT_NAME, 'random', 'words', 'here'].map {|k| Digest::MD5.hexdigest(k) }.join
  }
  config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
end

DO_NOT_REPLY = "donotreply@example.com"
