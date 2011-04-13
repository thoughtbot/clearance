module AuthorizationHelpers
  def sign_in_as(user)
    @controller.current_user = user
    return user
  end

  def sign_in
    sign_in_as Factory(:email_confirmed_user)
  end

  def sign_out
    @controller.current_user = nil
  end
end

RSpec.configure do |config|
  config.include AuthorizationHelpers
end
