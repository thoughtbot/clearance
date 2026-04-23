require "spec_helper"

describe Clearance::PasskeysController do
  it { should be_a Clearance::BaseController }

  describe "on GET to #new" do
    it "redirects unauthenticated requests to sign in" do
      get :new

      expect(response).to redirect_to(sign_in_url)
    end

    it "stores the challenge in session and returns creation options as JSON" do
      user = create(:user)
      sign_in_as(user)
      options = double(challenge: "the_challenge", to_json: '{"challenge":"the_challenge"}')
      allow(WebAuthn::Credential).to receive(:options_for_create).and_return(options)

      get :new

      expect(response).to have_http_status(:ok)
      expect(session[:passkey_creation_challenge]).to eq("the_challenge")
    end
  end

  describe "on POST to #create" do
    it "redirects unauthenticated requests to sign in" do
      post :create, params: {label: "My Key"}

      expect(response).to redirect_to(sign_in_url)
    end

    it "creates a passkey and responds with 201 when credential is valid" do
      user = create(:user)
      sign_in_as(user)
      session[:passkey_creation_challenge] = "the_challenge"
      credential = double(id: "cred_id", public_key: "pub_key", sign_count: 0)
      allow(WebAuthn::Credential).to receive(:from_create).and_return(credential)
      allow(credential).to receive(:verify)

      post :create, params: {label: "My Key"}

      expect(response).to have_http_status(:created)
      expect(user.passkeys.count).to eq(1)
    end

    it "returns unprocessable_content when credential verification fails" do
      user = create(:user)
      sign_in_as(user)
      session[:passkey_creation_challenge] = "the_challenge"
      credential = double
      allow(WebAuthn::Credential).to receive(:from_create).and_return(credential)
      allow(credential).to receive(:verify).and_raise(WebAuthn::Error, "bad credential")

      post :create, params: {label: "My Key"}

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
