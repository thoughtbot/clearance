require 'spec_helper'

class ApisController < ActionController::Base
  include Clearance::Controller

  before_filter :authorize

  respond_to :js

  def show
    render text: 'response'
  end

  protected

  def authorize
    deny_access 'Access denied.'
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
    subject.should respond_with(:unauthorized)
  end
end
