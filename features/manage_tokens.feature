Feature: Manage Oauth tokens for a user
  In create and verify Oauth tokens
  As an API user of SignNow
  I want to be able to generate and check for tokens


  Scenario: Getting or verifying a user token
    Given I am an API user of SignNow
    And I have a user
      | first_name   | last_name   | email                 | password |
      | Test-First-# | Test-Last-# | test-user@signnow.com | password |
    And I generate their tokens
    When I get the the user's token
    Then I should receive token data back


  Scenario: Generating a token for a user
    Given I am an API user of SignNow
    And I have a user
      | first_name   | last_name   | email                 | password |
      | Test-First-# | Test-Last-# | test-user@signnow.com | password |
    When I generate the the user's token
    Then I should receive token data back
    And I should have an access_token