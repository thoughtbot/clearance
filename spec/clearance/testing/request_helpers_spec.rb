require "spec_helper"

class SecretsController < ActionController::Base
  include Clearance::Controller

  before_action :require_login

  def index
    render json: { status: :ok }
  end
end

describe "Secrets managament", type: :request do
  before do
    Rails.application.routes.draw do
      clearance_routes_file = File.read(Rails.root.join("config", "routes.rb"))
      instance_eval(clearance_routes_file) # drawing clearance routes
      post "/my_sign_in" => "clearance/sessions#create", as: "my_sign_in"
      resources :secrets, only: :index
    end
  end

  describe "GET #index" do
    context "with default authenticated user" do
      it "renders action response" do
        sign_in

        get secrets_path

        expect(response.body).to eq({ status: :ok }.to_json)
      end
    end

    context "with custom authenticated user" do
      it "renders action response" do
        user = create(:user, password: "my-password")
        sign_in_as(user, password: "my-password")

        get secrets_path

        expect(response.body).to eq({ status: :ok }.to_json)
      end
    end

    context "with custom sign in path" do
      it "renders action response" do
        user = create(:user, password: "my-password")
        sign_in_as(user, password: "my-password", path: my_sign_in_path)

        get secrets_path

        expect(response.body).to eq({ status: :ok }.to_json)
      end
    end

    context "without authenticated user" do
      it "redirects to sign in" do
        get secrets_path

        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "with signed out user" do
      it "redirects to sign in" do
        sign_in

        get secrets_path

        expect(response.body).to eq({ status: :ok }.to_json)

        sign_out

        get secrets_path

        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
