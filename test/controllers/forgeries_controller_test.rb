require 'test_helper'

class ForgeriesController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery
  before_filter :authenticate

  # This is off in test by default, but we need it for this test
  self.allow_forgery_protection = true

  def create
    redirect_to :action => 'index'
  end
end

class ForgeriesControllerTest < ActionController::TestCase
  context "signed in user" do
    setup do
      Rails.application.routes.draw do
        resources :forgeries
        match 'sign_in'  => 'clearance/sessions#new', :as => 'sign_in'
      end

      @user = Factory(:user)
      @user.update_attribute(:remember_token, "old-token")
      @request.cookies["remember_token"] = "old-token"
      @request.session[:_csrf_token] = "golden-ticket"
    end

    teardown do
      Rails.application.reload_routes!
    end

    should "succeed with authentic token" do
      post :create, :authenticity_token => "golden-ticket"
      assert_redirected_to :action => 'index'
    end

    should "redirect to sign_in with invalid token" do
      post :create, :authenticity_token => "hax0r"
      assert_redirected_to sign_in_url
    end

    should "redirect to sign_in with no token" do
      post :create
      assert_redirected_to sign_in_url
    end
  end
end
