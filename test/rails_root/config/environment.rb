require File.join(File.dirname(__FILE__), 'boot')
require 'md5' # Need this up here to generate the session[:secret] value down there

Rails::Initializer.run do |config|
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  config.time_zone = 'Eastern Time (US & Canada)'
  config.action_controller.session = {
    :session_key => "_clearance_session",
    :secret      => ['clearance', 'random', 'words', 'here'].map {|k| Digest::MD5.hexdigest(k) }.join
  }
  config.gem 'mocha'
  config.gem 'thoughtbot-shoulda',
    :lib     => 'shoulda',
    :source  => "http://gems.github.com", 
    :version => '>= 2.0.6'
  config.gem 'thoughtbot-factory_girl',
    :lib     => 'factory_girl',
    :source  => "http://gems.github.com", 
    :version => '>= 1.1.5'
  config.gem "thoughtbot-clearance", 
    :lib     => 'clearance', 
    :source  => 'http://gems.github.com', 
    :version => '>= 0.3.8'  
end

DO_NOT_REPLY = "donotreply@example.com"
