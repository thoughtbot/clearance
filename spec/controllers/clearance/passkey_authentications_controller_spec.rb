require "spec_helper"

describe Clearance::PasskeyAuthenticationsController do
  it { should be_a Clearance::BaseController }

  describe "on GET to #new" do
    it "stores the challenge in session and returns authentication options as JSON" do
      options = double(challenge: "the_challenge", to_json: '{"challenge":"the_challenge"}')
      allow(WebAuthn::Credential).to receive(:options_for_get).and_return(options)

      get :new

      expect(response).to have_http_status(:ok)
      expect(session[:passkey_authentication_challenge]).to eq("the_challenge")
    end
  end

  describe "on POST to #create" do
    it "signs in the user and returns redirect URL when credential is valid" do
      user = create(:user)
      passkey = create(:passkey, user: user)
      session[:passkey_authentication_challenge] = "the_challenge"
      credential = double(id: passkey.external_id, sign_count: 1)
      allow(WebAuthn::Credential).to receive(:from_get).and_return(credential)
      allow(credential).to receive(:verify)

      post :create

      expect(response).to have_http_status(:ok)
      parsed = JSON.parse(response.body)
      expect(parsed["redirect_to"]).to eq(Clearance.configuration.redirect_url)
    end

    it "returns unauthorized when the passkey is not found" do
      session[:passkey_authentication_challenge] = "the_challenge"
      credential = double(id: "nonexistent_id")
      allow(WebAuthn::Credential).to receive(:from_get).and_return(credential)

      post :create

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns unprocessable_content when credential verification fails" do
      user = create(:user)
      passkey = create(:passkey, user: user)
      session[:passkey_authentication_challenge] = "the_challenge"
      credential = double(id: passkey.external_id)
      allow(WebAuthn::Credential).to receive(:from_get).and_return(credential)
      allow(credential).to receive(:verify).and_raise(WebAuthn::Error, "bad credential")

      post :create

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
