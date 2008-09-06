require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :all

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user       = User.find(:first)
  end

  should_be_restful do |resource|
    resource.identifier = :id
    resource.klass      = User
    resource.object     = :user
    resource.parent     = []
    resource.actions    = [:index, :show, :new, :edit, :update, :create, :destroy]
    resource.formats    = [:html, :xml]

    resource.create.params = { :name => "bob", :email => 'bob@bob.com', :age => 13, :ssn => "123456789"}
    resource.update.params = { :name => "sue" }

    resource.create.redirect  = "user_url(@user)"
    resource.update.redirect  = "user_url(@user)"
    resource.destroy.redirect = "users_url"

    resource.create.flash  = /created/i
    resource.update.flash  = /updated/i
    resource.destroy.flash = /removed/i
  end
end
