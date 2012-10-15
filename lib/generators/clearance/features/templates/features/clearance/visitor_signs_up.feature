Feature: Sign up

  In order to access protected sections of the site
  As a visitor
  I want to sign up

  Scenario: Visitor signs up with invalid email
    When I sign up with "invalidemail" and "password"
    Then I should be signed out

  Scenario: Visitor signs up with blank password
    When I sign up with "email@example.com" and ""
    Then I should be signed out

  Scenario: Visitor signs up with valid data
    When I sign up with "email@example.com" and "password"
    Then I should be signed in
