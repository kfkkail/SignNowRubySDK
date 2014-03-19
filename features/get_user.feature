Feature: Get a user
  In order to check if another users exists
  As an API user of SignNow
  I want to try getting data for that user


  Scenario: Querying for a user
    Given I am an API user of SignNow
    When I have a user
      | first_name | last_name | email | password |
      | Test-First-# | Test-Last-# | test-user@signnow.com | password |
    And I generate their tokens
    And I get the data for the user
    Then I should have data for the user
