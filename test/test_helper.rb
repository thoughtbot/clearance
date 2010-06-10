ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) +
                         "/rails_root/config/environment")
require 'rails/test_help'

$: << File.expand_path(File.dirname(__FILE__) + '/..')
require 'clearance'

begin
  require 'redgreen'
rescue LoadError
end

require File.join(File.dirname(__FILE__), '..', 'shoulda_macros', 'clearance')

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def self.should_set_cookie(name, value, should_expire_at)
    description = "set a '#{name}' cookie to '#{value}'"
    if should_expire_at
      description << " expiring at #{should_expire_at}"
    else
      description << " with no expiration date (session cookie)"
    end
    should description do
      assert_equal value, cookies[name]
      # the following statement may be redundant with the preceding one, but can't hurt
      assert_equal value, @response.cookies[name]
      # cookies and @response[cookies] don't give us the expire time, so we need to fish it out 'manually'
      set_cookie_headers = @response.headers['Set-Cookie']
      assert_not_nil set_cookie_headers, "@response.headers['Set-Cookie'] must not be nil"
      regex = /^#{name}=#{value}(;|$)/
      assert_contains set_cookie_headers, regex
      cookie = set_cookie_headers.find {|h| h =~ regex}
      regex = /; expires=(.*?)(;|$)/
      if should_expire_at
        assert_contains cookie, regex, "cookie does not contain an 'expires=' attribute"
        cookie =~ regex
        expires_at = Time.parse($1)
        assert_in_delta should_expire_at, expires_at, 100 # number of seconds we don't expect the test suite to exceed
      else
        assert_does_not_contain cookie, regex, "cookie contains an 'expires=' attribute but it shouldn't"
      end
    end
  end
end
