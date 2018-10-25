require "spec_helper"

describe "Cookie options" do
  before do
    Clearance.configuration.httponly = httponly
  end

  context "when httponly config value is false" do
    let(:httponly) { false }
    describe "sign in" do
      before do
        user = create(:user, password: "password")
        get sign_in_path

        post session_path, params: {
          session: { email: user.email, password: "password" },
        }
      end

      it { should_have_one_remember_token }

      it "should not have the httponly flag set" do
        expect(remember_token_cookies.last).not_to match(/HttpOnly/)
      end
    end
  end

  context "when httponly config value is true" do
    let(:httponly) { true }
    describe "sign in" do
      before do
        user = create(:user, password: "password")
        get sign_in_path

        post session_path, params: {
          session: { email: user.email, password: "password" },
        }
      end

      it { should_have_one_remember_token }

      it "should have the httponly flag set" do
        expect(remember_token_cookies.last).to match(/HttpOnly/)
      end
    end
  end

  def should_have_one_remember_token
    expect(remember_token_cookies.length).to eq(1),
      "expected one 'remember_token' cookie:\n#{remember_token_cookies}"
  end
end
