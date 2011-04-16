Feature: Sign in

  In order to get access to protected sections of the site
  As a visitor
  I want to sign in

  Scenario: Visitor is not signed up
    Given no user exists with an email of "email@person.com"
    When I go to the sign in page
    And I sign in as "email@person.com/password"
    Then I should see "Bad email or password"
    And I should be signed out

 Scenario: Visitor enters wrong password
    Given I am signed up as "email@person.com/password"
    When I go to the sign in page
    And I sign in as "email@person.com/wrongpassword"
    Then I should see "Bad email or password"
    And I should be signed out

 Scenario: Visitor signs in successfully
    Given I am signed up as "email@person.com/password"
    When I go to the sign in page
    Then I should see an email field
    And I sign in as "email@person.com/password"
    Then I should see "Signed in"
    And I should be signed in
    When I return next time
    Then I should be signed in

 Scenario: Visitor signs in successfully with uppercase email
    Given I am signed up as "email@person.com/password"
    When I go to the sign in page
    And I sign in as "Email@person.com/password"
    Then I should see "Signed in"
    And I should be signed in
    When I return next time
    Then I should be signed in
