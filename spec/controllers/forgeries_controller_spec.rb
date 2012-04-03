require 'spec_helper'

class ForgeriesController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery
  before_filter :authorize

  # This is off in test by default, but we need it for this test
  self.allow_forgery_protection = true

  def create
    redirect_to :action => 'index'
  end
end

describe ForgeriesController do
  context "signed in user" do
    before do
      Rails.application.routes.draw do
        resources :forgeries
        match 'sign_in'  => 'clearance/sessions#new', :as => 'sign_in'
      end

      @user = create(:user)
      @user.update_attribute(:remember_token, "old-token")
      @request.cookies["remember_token"] = "old-token"
      @request.session[:_csrf_token] = "golden-ticket"
    end

    after do
      Rails.application.reload_routes!
    end

    it "succeeds with authentic token" do
      post :create, :authenticity_token => "golden-ticket"
      subject.should redirect_to(:action => 'index')
    end

    it "fails with invalid token" do
      post :create, :authenticity_token => "hax0r"
      subject.should deny_access
    end

    it "fails with no token" do
      post :create
      subject.should deny_access
    end
  end
end
