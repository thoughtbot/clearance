require 'spec_helper'

class ForgeriesController < ActionController::Base
  include Clearance::Controller

  protect_from_forgery

  before_action :require_login

  # This is off in test by default, but we need it for this test
  self.allow_forgery_protection = true

  def create
    redirect_to action: 'index'
  end
end

describe ForgeriesController do
  context 'signed in user' do
    before do
      Rails.application.routes.draw do
        resources :forgeries
        get '/sign_in'  => 'clearance/sessions#new', as: 'sign_in'
      end

      @user = create(:user)
      @user.update_attribute(:remember_token, 'old-token')
      @request.cookies['remember_token'] = 'old-token'
    end

    after do
      Rails.application.reload_routes!
    end

    it 'succeeds with authentic token' do
      token = controller.send(:form_authenticity_token)
      post :create, params: {
        authenticity_token: token,
      }
      expect(subject).to redirect_to(action: 'index')
    end

    it 'fails with invalid token' do
      post :create, params: {
        authenticity_token: "hax0r",
      }
      expect(subject).to deny_access
    end

    it 'fails with no token' do
      post :create
      expect(subject).to deny_access
    end
  end
end
