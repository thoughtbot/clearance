RSpec::Matchers.define :set_cookie do |name, value, expected_expires_at|
  match do |subject|
    @response            = subject.response
    @name                = name
    @value               = value
    @expected_expires_at = expected_expires_at

    extract_cookies
    find_expected_cookie
    parse_expiration

    ensure_cookie_set
    ensure_value_correct
    ensure_expiration_correct
  end

  def extract_cookies
    @cookie_headers = @response.headers['Set-Cookie'] || []
    @cookie_headers = [@cookie_headers] if @cookie_headers.respond_to?(:to_str)
  end

  def find_expected_cookie
    @cookie = @cookie_headers.detect do |header|
      header =~ /^#{@name}=[^;]*(;|$)/
    end
  end

  def parse_expiration
    if @cookie && result = @cookie.match(/; expires=(.*?)(;|$)/)
      @expires_at = Time.parse(result[1])
    end
  end

  def ensure_cookie_set
    @cookie.should_not be_nil
  end

  def ensure_value_correct
    @response.cookies[@name].should == @value
  end

  def ensure_expiration_correct
    if @expected_expires_at
      @expires_at.should_not be_nil
      @expires_at.should be_within(100).of(@expected_expires_at)
    else
      @expires_at.should be_nil
    end
  end

  failure_message do
    "Expected #{expectation} got #{result}"
  end

  def expectation
    base = "Expected a cookie named #{@name} with value #{@value.inspect} "
    if @expected_expires_at
      base << "expiring at #{@expected_expires_at.inspect}"
    else
      base << "with no expiration"
    end
    base
  end

  def result
    if @cookie
      "value #{@value.inspect} expiring #{@expires_at.inspect}"
    else
      "cookies #{@response.cookies.inspect}"
    end
  end
end
