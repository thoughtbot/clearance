require 'spec_helper'

class ApisController < ActionController::Base
  include Clearance::Controller

  before_action :require_login

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
