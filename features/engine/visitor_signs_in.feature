Feature: Sign in

  In order to get access to protected sections of the site
  As a visitor
  I want to sign in

  Scenario: Visitor is not signed up
    Given no user exists with an email of "email@example.com"
    When I go to the sign in page
    And I sign in as "email@example.com"
    Then I should see "Bad email or password"
    And I should be signed out

 Scenario: Visitor enters wrong password
    Given I am signed up as "email@example.com"
    When I go to the sign in page
    And I fill in "Email" with "email@example.com"
    And I fill in "Password" with "badpassword"
    And I press "Sign in"
    Then I should see "Bad email or password"
    And I should be signed out

 Scenario: Visitor signs in successfully
    Given I am signed up as "email@example.com"
    When I go to the sign in page
    Then I should see an email field
    And I sign in as "email@example.com"
    Then I should be signed in

 Scenario: Visitor signs in successfully with uppercase email
    Given I am signed up as "email@example.com"
    When I go to the sign in page
    And I sign in as "Email@example.com"
    Then I should be signed in
