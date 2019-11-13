require "spec_helper"

class PagesController < ApplicationController
  include Clearance::Controller
  before_action :require_login, only: :private

  # A page requiring user authentication
  def private
    head :ok
  end

  # A page that does not require user authentication
  def public
    head :ok
  end
end

describe "Authentication cookies in the response" do
  before do
    draw_test_routes
    create_user_and_sign_in
  end

  after do
    Rails.application.reload_routes!
  end

  it "are not present if the request does not authenticate" do
    get public_path

    expect(headers["Set-Cookie"]).to be_nil
  end

  it "are present if the request does authenticate" do
    get private_path

    expect(headers["Set-Cookie"]).to match(/remember_token=/)
  end

  def draw_test_routes
    Rails.application.routes.draw do
      get "/private" => "pages#private", as: :private
      get "/public" => "pages#public", as: :public
      resource :session, controller: "clearance/sessions", only: [:create]
    end
  end

  def create_user_and_sign_in
    user = create(:user, password: "password")

    post session_path, params: {
      session: { email: user.email, password: "password" },
    }
  end
end
