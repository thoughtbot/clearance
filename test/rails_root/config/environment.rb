require File.join(File.dirname(__FILE__), 'boot')
require 'digest/md5'

RAILS_GEM_VERSION = "2.3.5"

Rails::Initializer.run do |config|
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  config.time_zone = 'Eastern Time (US & Canada)'
  config.action_controller.session = {
    :session_key => "_clearance_session",
    :secret      => ['clearance', 'random', 'words', 'here'].map {|k| Digest::MD5.hexdigest(k) }.join
  }

  config.gem "justinfrench-formtastic", 
    :lib     => 'formtastic', 
    :source  => 'http://gems.github.com'

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
end
