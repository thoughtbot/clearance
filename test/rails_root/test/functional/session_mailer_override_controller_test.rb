require File.dirname(__FILE__) + '/../test_helper'

class SessionMailerOverridesControllerTest < ActionController::TestCase
  context "an unconfirmed User" do
    setup do
      @user = Factory(:user, :confirmed => false)
    end

    context "on GET to create with valid params" do
      setup do
        post :create, :session => {
          :email => @user.email,
          :password => @user.password
        }
      end

      before_should "use the ClearanceOverrideMailer" do
        ClearanceOverrideMailer.expects(:deliver_confirmation).with(@user)
      end
    end
  end
end
