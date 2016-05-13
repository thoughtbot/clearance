require 'spec_helper'

class PermissionsController < ActionController::Base
  include Clearance::Controller

  before_action :require_login, only: :show

  def new
    head :ok
  end

  def show
    head :ok
  end
end

describe PermissionsController do
  before do
    Rails.application.routes.draw do
      resource :permission, only: [:new, :show]
      get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  context 'with signed in user' do
    before { sign_in }

    it 'allows access to new' do
      get :new

      expect(subject).not_to deny_access
    end

    it 'allows access to show' do
      get :show

      expect(subject).not_to deny_access
    end
  end

  context 'with visitor' do
    it 'allows access to new' do
      get :new

      expect(subject).not_to deny_access
    end

    it 'denies access to show' do
      get :show

      expect(subject).to deny_access(redirect: sign_in_url)
    end

    it "denies access to show and display a flash message" do
      get :show

      expect(flash[:alert]).to match(/^Please sign in to continue/)
    end
  end

  context 'when remember_token is blank' do
    it 'denies acess to show' do
      user = create(:user)
      user.update_attributes(remember_token: '')
      cookies[:remember_token] = ''

      get :show

      expect(subject).to deny_access
    end
  end
end
