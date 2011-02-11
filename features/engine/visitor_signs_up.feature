Feature: Sign up

  In order to get access to protected sections of the site
  As a visitor
  I want to sign up

  Scenario: Visitor signs up with invalid data
    When I go to the sign up page
    And I fill in "Email" with "invalidemail"
    And I fill in "Password" with "password"
    And I fill in "Confirm password" with ""
    And I press "Sign up"
    Then I should see error messages

  Scenario: Visitor signs up with valid data
    When I go to the sign up page
    And I fill in "Email" with "email@person.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm password" with "password"
    And I press "Sign up"
    Then I should see "signed up"
