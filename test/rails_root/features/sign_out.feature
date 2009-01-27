Feature: Sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out
  
    Scenario: User signs out
      Given I am signed up and confirmed as "email@person.com/password"
      When I sign in as "email@person.com/password"
      Then I should be signed in
      And I sign out
      Then I should see "You have been signed out"     
      And I should not be signed in
      
    Scenario: User who was remembered signs out
      Given I am signed up and confirmed as "email@person.com/password"
      When I sign in with "remember me" as "email@person.com/password"
      Then I should be signed in
      And I sign out
      Then I should see "You have been signed out"     
      And I should not be signed in
      When I return next time
      Then I should not be signed in  
