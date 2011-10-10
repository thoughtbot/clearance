Feature: Password reset

  In order to sign in even if I forgot my password
  As a user
  I want to reset my password

  Scenario: User is not signed up
    When I reset the password for "unknown.email@example.com"
    Then I am told email is unknown

  Scenario: User is signed up and requests password reset
    Given I signed up with "email@example.com"
    When I reset the password for "email@example.com"
    Then instructions for changing my password are emailed to "email@example.com"

  Scenario: User tries to reset his password with a blank password
    Given I signed up with "email@example.com"
    When I reset the password for "email@example.com"
    And I follow the password reset link sent to "email@example.com"
    And I update my password with ""
    Then I am told to enter a password
    And I should be signed out

  Scenario: User is signed up and updates his password
    Given I signed up with "email@example.com"
    When I reset the password for "email@example.com"
    And I follow the password reset link sent to "email@example.com"
    And I update my password with "newpassword"
    Then I should be signed in
    When I sign out
    Then I should be signed out
    When I sign in with "email@example.com" and "newpassword"
    Then I should be signed in

  Scenario: User who was created before Clearance was installed creates password for first time
    Given a user "email@example.com" exists without a salt, remember token, or password
    When I reset the password for "email@example.com"
    When I follow the password reset link sent to "email@example.com"
    And I update my password with "newpassword"
    Then I should be signed in

