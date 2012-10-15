Feature: install and run cucumber features

  Background:
    Given I have a project with clearance and the following gems:
     | gem                  |
     | cucumber-rails       |
     | capybara             |
     | rspec-rails          |
     | factory_girl_rails   |
     | database_cleaner     |
    And I run `bundle install --local`
    And I successfully run `bundle exec rails generate cucumber:install`
    And I successfully run `bundle exec rails generate clearance:features`
    And I successfully run `bundle exec rails generate clearance:install`

  Scenario: generate a Rails app, run the generators, and run the tests
    Then the output should contain "Next steps"
    When I successfully run `bundle exec rake db:migrate --trace`
    And I successfully run `bundle exec rake --trace`
    Then the output should contain "passed"
    And the output should not contain "failed"
    And the output should not contain "Could not find generator"