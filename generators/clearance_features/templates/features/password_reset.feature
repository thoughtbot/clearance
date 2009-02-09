Fature: Password Reset
  In order to sign in even if he forgot his password
  A user
  Should be able to reset it
  
    Scenario: User is not signed up
      Given there is no user with "email@person.com"
      When I request password reset link to be sent to "email@person.com"
      Then I should see "Unknown email"
  
    Scenario: User requests password reset
      Given I am signed up and confirmed as "email@person.com/password"
      When I request password reset link to be sent to "email@person.com"
      Then I should see "Details for changing your password have been sent to email@person.com"
      And a password reset message should be sent to "email@person.com"
      
    Scenario: User updated his password and types wrong confirmation
      Given I am signed up and confirmed as "email@person.com/password"
      When I follow the password reset link sent to "email@person.com"
      And I update my password with "newpassword/wrongconfirmation"
      Then I should see error messages
      And I should not be signed in      
      
    Scenario: User updates his password
      Given I am signed up and confirmed as "email@person.com/password"
      When I follow the password reset link sent to "email@person.com"
      And I update my password with "newpassword/newpassword"
      Then I should be signed in
      When I sign out
      And I sign in as "email@person.com/newpassword"
      Then I should be signed in
      
