require "spec_helper"

describe "CSRF Rotation" do
  around do |example|
    ActionController::Base.allow_forgery_protection = true
    example.run
    ActionController::Base.allow_forgery_protection = false
  end

  context "Clearance is configured to rotate CSRF token on sign in" do
    describe "sign in" do
      it "rotates the CSRF token" do
        Clearance.configure { |config| config.rotate_csrf_on_sign_in = true }
        get sign_in_path
        user = create(:user, password: "password")
        original_token = csrf_token

        post session_path, session: session_params(user, "password")

        expect(csrf_token).not_to eq original_token
        expect(csrf_token).to be_present
      end
    end
  end

  def csrf_token
    session[:_csrf_token]
  end

  def session_params(user, password)
    { email: user.email, password: password, authenticity_token: csrf_token }
  end
end
