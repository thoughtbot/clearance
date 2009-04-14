require 'test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :users, :controller => 'dummy', :only => :show
end

class DummyController < ApplicationController
  before_filter :dummy_sign_in

  def show
    render :nothing => true
  end

  def dummy_sign_in
    user = User.find(params[:id])
    sign_user_in(user)
  end
end

class ApplicationControllerTest < ActionController::TestCase
  tests ::DummyController

  context "on GET to show" do
    setup do

      @user = Factory(:email_confirmed_user)
      get :show, :id => @user.id
    end

    should "assign the current_user" do
      assert_equal @user, @controller.current_user
    end
  end
end
