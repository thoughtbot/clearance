Feature: integrate with test-unit

  Background:
    Given I have a project with clearance and the following gems:
      | gem                |
      | factory_girl_rails |
      | cucumber-rails     |

  Scenario: generate a Rails app, run the generators, and run the tests
    When I install dependencies
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `bundle exec rake db:migrate`
    And I successfully run `bundle exec rails generate controller posts index`
    And I configure test-unit
    And I successfully run `bundle exec rake`
    Then the output should match /1 tests.+1 assertions/
