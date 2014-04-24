Feature: copy routes to host application

   Background:
    Given I have a project with clearance

   Scenario:
    When I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `bundle exec rails generate clearance:routes`
    Then the file "config/initializers/clearance.rb" should contain "config.routes = false"
    And the file "config/routes.rb" should contain "get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'"
