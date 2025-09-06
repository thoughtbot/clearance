module RememberTokenHelpers
  def request_with_remember_token(remember_token)
    cookies = ActionDispatch::Request.new({}).cookie_jar
    if Clearance.configuration.signed_cookie
      cookies.signed[Clearance.configuration.cookie_name] = remember_token
    else
      cookies[Clearance.configuration.cookie_name] = remember_token
    end

    env = {clearance: Clearance::Session.new(cookies.request.env)}
    Rack::Request.new env
  end

  def request_without_remember_token
    request_with_remember_token nil
  end

  def remember_token_cookies
    set_cookie_header = headers["Set-Cookie"] || headers["set-cookie"]
    cookie_lines = Array(set_cookie_header).join("\n").lines.map(&:chomp)
    cookie_lines.select { |name| name =~ /^remember_token/ }
  end
end

RSpec.configure do |config|
  config.include RememberTokenHelpers
end
