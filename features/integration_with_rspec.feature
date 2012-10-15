Feature: generate rspec integration tests with application

  Background:
    Given I have a project with clearance and the following gems:
      | gem                |
      | capybara           |
      | rspec-rails        |
      | factory_girl_rails |
      | database_cleaner   |
    And I run `bundle install --local`
    And I successfully run `bundle exec rails generate rspec:install`
    And I successfully run `bundle exec rails generate clearance:specs`

  Scenario: generate a Rails app, run the generators, and run the tests
    And I successfully run `bundle exec rails generate clearance:install`
    Then the output should contain "Next steps"
    When I successfully run `bundle exec rake db:migrate --trace`
    And I successfully run `bundle exec rspec`
    Then the output should contain "Finished"
    And the output should not contain "Failed examples"
    And the output should not contain "Could not find generator"
