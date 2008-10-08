require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

# Re-raise errors caught by the controller.
class PostsController; def rescue_action(e) raise e end; end

class PostsControllerTest < Test::Unit::TestCase
  fixtures :all

  def setup
    @controller = PostsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @post       = Post.find(:first)
  end
  
  # autodetects the :controller
  should_route :get,    '/posts',     :action => :index
  # explicitly specify :controller
  should_route :post,   '/posts',     :controller => :posts, :action => :create
  # non-string parameter
  should_route :get,    '/posts/1',   :action => :show, :id => 1
  # string-parameter
  should_route :put,    '/posts/1',   :action => :update, :id => "1"
  should_route :delete, '/posts/1',   :action => :destroy, :id => 1
  should_route :get,    '/posts/new', :action => :new
  
  # Test the nested routes
  should_route :get,    '/users/5/posts',     :action => :index, :user_id => 5
  should_route :post,   '/users/5/posts',     :action => :create, :user_id => 5
  should_route :get,    '/users/5/posts/1',   :action => :show, :id => 1, :user_id => 5
  should_route :delete, '/users/5/posts/1',   :action => :destroy, :id => 1, :user_id => 5
  should_route :get,    '/users/5/posts/new', :action => :new, :user_id => 5
  should_route :put,    '/users/5/posts/1',   :action => :update, :id => 1, :user_id => 5

  context "The public" do
    setup do
      @request.session[:logged_in] = false
    end

    should_be_restful do |resource|
      resource.parent = :user

      resource.denied.actions = [:index, :show, :edit, :new, :create, :update, :destroy]
      resource.denied.flash = /what/i
      resource.denied.redirect = '"/"'
    end
  end

  context "Logged in" do
    setup do
      @request.session[:logged_in] = true
    end

    should_be_restful do |resource|
      resource.parent = :user

      resource.create.params = { :title => "first post", :body => 'blah blah blah'}
      resource.update.params = { :title => "changed" }
    end

    context "viewing posts for a user" do
      setup do
        get :index, :user_id => users(:first)
      end
      should_respond_with :success
      should_assign_to :user, :class => User, :equals => 'users(:first)'
      should_fail do
        should_assign_to :user, :class => Post
      end
      should_fail do
        should_assign_to :user, :equals => 'posts(:first)'
      end
      should_assign_to :posts
      should_not_assign_to :foo, :bar
    end

    context "viewing posts for a user with rss format" do
      setup do
        get :index, :user_id => users(:first), :format => 'rss'
        @user = users(:first)
      end
      should_respond_with :success
      should_respond_with_content_type 'application/rss+xml'
      should_respond_with_content_type :rss
      should_respond_with_content_type /rss/
      should_return_from_session :special, "'$2 off your next purchase'"
      should_return_from_session :special_user_id, '@user.id'
      should_assign_to :user, :posts
      should_not_assign_to :foo, :bar
    end

    context "viewing a post on GET to #show" do
      setup { get :show, :user_id => users(:first), :id => posts(:first) }
      should_render_with_layout 'wide'
    end

    context "on GET to #new" do
      setup { get :new, :user_id => users(:first) }
      should_render_without_layout
    end
  end

end
