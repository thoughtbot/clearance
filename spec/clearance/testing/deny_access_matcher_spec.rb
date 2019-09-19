require "spec_helper"

class PretendFriendsController < ActionController::Base
  include Clearance::Controller
  before_action :require_login

  def index
  end
end

describe PretendFriendsController, type: :controller do
  before do
    Rails.application.routes.draw do
      resources :pretend_friends, only: :index
      get "/sign_in"  => "clearance/sessions#new", as: "sign_in"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  it "checks contents of deny access flash" do
    get :index

    expect(subject).to deny_access(flash: failure_message)
  end

  def failure_message
    I18n.t("flashes.failure_when_not_signed_in")
  end
end
