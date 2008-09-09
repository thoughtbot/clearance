require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  include Clearance::SessionsControllerTest
  
end