require "spec_helper"

describe "cookie options" do
  before do
    Clearance.configuration.httponly = httponly
  end

  context "when httponly config value false" do
    let(:httponly) { false }
    describe "sign in" do
      before do
        get sign_in_path
        user = create(:user, password: "password")

        post session_path,
             params: { session: { email: user.email, password: "password" } }
        @remember_token_cookies = headers["Set-Cookie"].
          split("\n").
          select { |v| v =~ /^remember_token/ }
      end

      it "should have one remember_token cookie" do
        expect(@remember_token_cookies.length).to(
          eq(1),
          "expected one 'remember_token' cookie:\n#{@remember_token_cookies}",
        )
      end

      it "should not have the httponly flag set" do
        expect(@remember_token_cookies.last).to_not match(/httponly/i)
      end
    end
  end

  context "when httponly config value true" do
    let(:httponly) { true }
    describe "sign in" do
      before do
        get sign_in_path
        user = create(:user, password: "password")

        post session_path,
             params: { session: { email: user.email, password: "password" } }
        @remember_token_cookies = headers["Set-Cookie"].
          split("\n").
          select { |v| v =~ /^remember_token/ }
      end

      it "should have one remember_token cookie" do
        expect(@remember_token_cookies.length).to(
          eq(1),
          "expected one 'remember_token' cookie:\n#{@remember_token_cookies}",
        )
      end

      it "should have the httponly flag set" do
        expect(@remember_token_cookies.last).to match(/httponly/i)
      end
    end
  end
end
