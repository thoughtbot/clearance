Feature: add migrations to the project

  Background:
    Given I have a project with clearance

  Scenario: Users table does not exist
    When I install dependencies
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `ls db/migrate`
    Then the output should contain:
      """
      create_users.rb
      """

  Scenario: Users table without clearance fields exists in the database
    When I install dependencies
    And I create a simple user model
    And I add an existing user
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `bundle exec rake db:migrate`
    Then the output should contain:
      """
      add_clearance_to_users.rb
      """
    And the existing user should have a remember token

  Scenario: Users table with clearance fields exists in the database
    When I install dependencies
    And I create a migration with clearance fields
    And I successfully run `bundle exec rake db:migrate`
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `ls db/migrate`
    Then the output should not contain:
      """
      add_clearance_to_users.rb
      """
