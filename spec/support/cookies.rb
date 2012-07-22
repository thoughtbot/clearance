RSpec::Matchers.define :set_cookie do |name, expected_value, expected_expires_at|
  failure_message_for_should do
    "Expected #{expectation} got #{result}"
  end

  match do |subject|
    @headers = subject
    @expected_name = name
    @expected_value = expected_value
    @expected_expires_at = expected_expires_at
    extract_cookies
    find_expected_cookie
    parse_expiration
    parse_value
    parse_path
    ensure_cookie_set
    ensure_expiration_correct
    ensure_path_is_correct
  end

  def ensure_cookie_set
    @value.should == @expected_value
  end

  def ensure_expiration_correct
    @expires_at.should_not be_nil
    @expires_at.should be_within(100).of(@expected_expires_at)
  end

  def ensure_path_is_correct
    @path.should == "/"
  end

  def expectation
    "a cookie named #{@expected_name} with value #{@expected_value.inspect} expiring at #{@expected_expires_at.inspect}"
  end

  def extract_cookies
    @cookie_headers = @headers['Set-Cookie'] || []
    @cookie_headers = [@cookie_headers] if @cookie_headers.respond_to?(:to_str)
  end

  def find_expected_cookie
    @cookie = @cookie_headers.detect do |header|
      header =~ /^#{@expected_name}=[^;]*(;|$)/
    end
  end

  def parse_expiration
    if @cookie && result = @cookie.match(/; expires=(.*?)(;|$)/)
      @expires_at = Time.parse(result[1])
    end
  end

  def parse_path
    if @cookie && result = @cookie.match(/; path=(.*?)(;|$)/)
      @path = result[1]
    end
  end

  def parse_value
    if @cookie && result = @cookie.match(/=(.*?)(?:;|$)/)
      @value = result[1]
    end
  end

  def result
    if @cookie
      @cookie
    else
      @cookie_headers.join("; ")
    end
  end
end
