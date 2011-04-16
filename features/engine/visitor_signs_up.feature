Feature: Sign up

  In order to get access to protected sections of the site
  As a visitor
  I want to sign up

  Background:
    When I go to the sign up page
    Then I should see an email field

  Scenario: Visitor signs up with invalid email
    When I fill in "Email" with "invalidemail"
    And I fill in "Password" with "password"
    And I press "Sign up"
    Then I should see "Email is invalid"

  Scenario: Visitor signs up with blank password
    When I fill in "Email" with "email@example.com"
    And I fill in "Password" with ""
    And I press "Sign up"
    Then I should see "Password can't be blank"

  Scenario: Visitor signs up with valid data
    When I fill in "Email" with "email@example.com"
    And I fill in "Password" with "password"
    And I press "Sign up"
    Then I should see "signed up"
