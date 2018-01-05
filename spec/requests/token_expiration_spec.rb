require "spec_helper"

describe "token expiration" do
  describe "after sign-in" do
    before do
      get sign_in_path
      user = create(:user, password: "password")

      post session_path,
           params: { session: { email: user.email, password: "password" } }
      @remember_token_cookies = headers["Set-Cookie"].
        split("\n").
        select { |v| v =~ /^remember_token/ }
    end

    it "should have a remember_token cookie with an expiration of <>" do
      cookie_hash = cookie_to_hash(@remember_token_cookies.last)
      expect(cookie_hash["expires"]).to(
        be_between(1.years.from_now - 1.second, 1.years.from_now),
      )
    end
  end

  describe "after sign-in and another request" do
    before do
      get sign_in_path
      user = create(:user, password: "password")

      post session_path,
           params: { session: { email: user.email, password: "password" } }
      @first_remember_token_cookies = headers["Set-Cookie"].
        split("\n").
        select { |v| v =~ /^remember_token/ }

      sleep 2
      get root_path
      @second_remember_token_cookies = headers["Set-Cookie"].
        split("\n").
        select { |v| v =~ /^remember_token/ }
    end

    it "sets a new remember_token on every request with updated expiration" do
      expect(@second_remember_token_cookies.last).to(
        be,
        "remember token wasn't set on second request",
      )

      first_expiration =
        cookie_to_hash(@first_remember_token_cookies.last)["expires"]
      second_expiration =
        cookie_to_hash(@second_remember_token_cookies.last)["expires"]
      expect(second_expiration).to be > first_expiration
    end
  end

  def cookie_to_hash(cookie_string)
    elements = cookie_string.split(/;\s+/)
    pairs = elements.map { |ele| ele.split("=") }

    name = pairs[0][0]
    value = pairs[0][1]
    h = Hash[pairs].merge("name" => name, "value" => value)
    h["expires"] = Time.parse(h["expires"])
    h
  end
end
