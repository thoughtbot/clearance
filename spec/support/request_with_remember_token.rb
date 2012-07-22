module RememberTokenHelpers
  def request_with_remember_token(remember_token)
    cookies = {
      'action_dispatch.cookies' => {
        Clearance::Session::REMEMBER_TOKEN_COOKIE => remember_token
      }
    }
    env = { :clearance => Clearance::Session.new(cookies) }
    Rack::Request.new env
  end

  def request_without_remember_token
    request_with_remember_token nil
  end
end

RSpec.configure do |config|
  config.include RememberTokenHelpers
end
