Feature: Sign in

  In order to get access to protected sections of the site
  As a visitor
  I want to sign in

  Scenario: Visitor is not signed up
    When I sign in as "unknown.email@example.com"
    Then I am told email or password is bad
    And I should be signed out

 Scenario: Visitor enters wrong password
    Given I am signed up as "email@example.com"
    When I sign in as "email@example.com" and "badpassword"
    Then I am told email or password is bad
    And I should be signed out

 Scenario: Visitor signs in successfully
    Given I am signed up as "email@example.com"
    When I sign in as "email@example.com"
    Then I should be signed in

 Scenario: Visitor signs in successfully with uppercase email
    Given I am signed up as "email@example.com"
    When I sign in as "Email@example.com"
    Then I should be signed in

 Scenario: Visitor enters wrong password and goes to sign up
    Given I am signed up as "email@example.com"
    When I sign in as "email@example.com" and "badpassword"
    Then I am told email or password is bad
    When I follow the sign up link in the flash
    Then I should be on the sign up page
