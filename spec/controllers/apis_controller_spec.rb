require 'spec_helper'

class ApisController < ActionController::Base
  include Clearance::Controller

  if respond_to?(:before_action)
    before_action :require_login
  else
    before_filter :require_login
  end

  def show
    head :ok
  end
end

describe ApisController do
  before do
    Rails.application.routes.draw do
      resource :api, only: [:show]
    end
  end

  after do
    Rails.application.reload_routes!
  end

  it 'responds with HTTP status code 401 when denied' do
    get :show, format: :js
    expect(subject).to respond_with(:unauthorized)
  end
end
