require 'spec_helper'

class PermissionsController < ActionController::Base
  include Clearance::Controller

  before_filter :require_login, only: :show

  def new
    render text: 'New page'
  end

  def show
    render text: 'Show page'
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
