Feature: integrate with test unit

  Background:
    When I successfully run `bundle exec rails new testapp`
    And I cd to "testapp"
    And I remove the file "public/index.html"
    And I remove the file "app/views/layouts/application.html.erb"
    And I configure ActionMailer to use "localhost" as a host
    And I configure a root route
    And I add the "factory_girl_rails" gem
    And I run `bundle install --local`

  Scenario: generate a Rails app, run the generators, and run the tests
    When I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `bundle exec rake db:migrate --trace`
    And I successfully run `bundle exec rails generate controller posts index`
    And I add the "cucumber-rails" gem
    And I write to "test/test_helper.rb" with:
    """
    ENV['RAILS_ENV'] = 'test'
    require File.expand_path('../../config/environment', __FILE__)
    require 'rails/test_help'

    class ActiveSupport::TestCase
      fixtures :all
    end

    require 'clearance/testing'
    """
    And I write to "test/functionals/posts_controller_test.rb" with:
    """
    require 'test_helper'

    class PostsControllerTest < ActionController::TestCase
      test 'should get index' do
        sign_in
        get :index
        assert_response :success
      end
    end
    """
    And I successfully run `bundle exec rake --trace`
    Then the output should contain "1 tests, 1 assertions, 0 failures"
