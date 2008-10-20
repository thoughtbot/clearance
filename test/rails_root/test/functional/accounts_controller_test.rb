require File.dirname(__FILE__) + '/../test_helper'

class AccountsControllerTest < ActionController::TestCase
  public_context do
    should_deny_access_on 'get :edit'
    should_deny_access_on 'put :update'
  end
end
