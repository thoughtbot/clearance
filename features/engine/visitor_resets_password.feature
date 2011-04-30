Feature: Password reset

  In order to sign in even if I forgot my password
  As a user
  I want to reset my password

  Scenario: User is not signed up
    Given no user exists with an email of "email@example.com"
    When I request password reset link to be sent to "email@example.com"
    Then I should see "Unknown email"

  Scenario: User is signed up and requests password reset
    Given I signed up with "email@example.com/password"
    When I request password reset link to be sent to "email@example.com"
    Then I should see "instructions for changing your password"
    And a password reset message should be sent to "email@example.com"

  Scenario: User tries to reset his password with a blank password
    Given I signed up with "email@example.com/password"
    And I go to the password reset request page
    Then I should see an email field
    And I fill in "Email address" with "email@example.com"
    And I press "Reset password"
    When I follow the password reset link sent to "email@example.com"
    And I update my password with ""
    Then I should see "Password can't be blank."
    And I should be signed out

  Scenario: User is signed up and updates his password
    Given I signed up with "email@example.com/password"
    And I go to the password reset request page
    And I fill in "Email address" with "email@example.com"
    And I press "Reset password"
    When I follow the password reset link sent to "email@example.com"
    And I update my password with "newpassword"
    Then I should be signed in
    When I sign out
    Then I should be signed out
    And I sign in as "email@example.com/newpassword"
    Then I should be signed in

  Scenario: User who was created before Clearance was installed creates password for first time
    Given a user "email@example.com" exists without a salt, remember token, or password
    When I go to the password reset request page
    And I fill in "Email address" with "email@example.com"
    And I press "Reset password"
    When I follow the password reset link sent to "email@example.com"
    And I update my password with "newpassword"
    Then I should be signed in

