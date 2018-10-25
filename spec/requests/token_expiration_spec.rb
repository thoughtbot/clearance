require "spec_helper"

describe "Token expiration" do
  describe "after signing in" do
    before do
      create_user_and_sign_in
      @initial_cookies = remember_token_cookies
    end

    it "should have a remember_token cookie with a future expiration" do
      expect(first_cookie.expires).to be_between(
        1.years.from_now - 1.second,
        1.years.from_now,
      )
    end
  end

  describe "after signing in and making a followup request" do
    before do
      create_user_and_sign_in
      @initial_cookies = remember_token_cookies

      Timecop.travel(1.minute.from_now) do
        get root_path
        @followup_cookies = remember_token_cookies
      end
    end

    it "should set a remember_token on each request with updated expiration" do
      expect(@followup_cookies.length).to be >= 1,
        "remember token wasn't set on second request"

      expect(second_cookie.expires).to be > first_cookie.expires
    end
  end

  def first_cookie
    Rack::Test::Cookie.new @initial_cookies.last
  end

  def second_cookie
    Rack::Test::Cookie.new @followup_cookies.last
  end

  def create_user_and_sign_in
    user = create(:user, password: "password")

    get sign_in_path

    post session_path, params: {
      session: { email: user.email, password: "password" },
    }
  end
end
