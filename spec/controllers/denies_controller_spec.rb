require 'spec_helper'

class DeniesController < ActionController::Base
  include Clearance::Authentication
  before_filter :authorize, :only => :show

  def new
    render :text => "New page"
  end

  def show
    render :text => "Show page"
  end

  protected

  def authorize
    deny_access("Access denied.")
  end
end

describe DeniesController do
  before do
    Rails.application.routes.draw do
      resource :deny, :only => [:new, :show]
      match 'sign_in'  => 'clearance/sessions#new', :as => 'sign_in'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  context "signed in user" do
    before { sign_in }

    it "allows access to new" do
      get :new
      subject.should_not deny_access
    end

    it "denies access to show" do
      get :show
      subject.should deny_access(:redirect => '/')
    end
  end

  context "visitor" do
    it "allows access to new" do
      get :new
      subject.should_not deny_access
    end

    it "denies access to show" do
      get :show
      subject.should deny_access
      subject.should deny_access(:redirect => sign_in_url, :flash => "Access denied.")
    end
  end
end
