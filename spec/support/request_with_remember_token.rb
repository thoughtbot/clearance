module RememberTokenHelpers
  def request_with_remember_token(remember_token)
    cookies = {
      'action_dispatch.cookies' => {
        Clearance.configuration.cookie_name => remember_token
      }
    }
    env = { clearance: Clearance::Session.new(cookies) }
    Rack::Request.new env
  end

  def request_without_remember_token
    request_with_remember_token nil
  end

  def remember_token_cookies
    cookie_lines = headers["Set-Cookie"].lines.map(&:chomp)
    cookie_lines.select { |name| name =~ /^remember_token/ }
  end
end

RSpec.configure do |config|
  config.include RememberTokenHelpers
end
