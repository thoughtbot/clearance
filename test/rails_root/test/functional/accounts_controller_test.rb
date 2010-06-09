require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  context "when signed out" do
    setup { sign_out }
    should_deny_access_on :get, :edit
    should_deny_access_on :put, :update
  end

  context "on POST to create" do
    setup do
      post :create
    end

    should_deny_access

    should "not store location" do
      assert session[:return_to].nil?
    end
  end

end
