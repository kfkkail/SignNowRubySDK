Feature: Create a user
  In order to send documents to another user
  As an API user of SignNow
  I want to create another user

  Scenario: Creating another user
    Given I am an API user of SignNow
    When I have a user
      | first_name   | last_name   | email                 | password |
      | Test-First-# | Test-Last-# | test-user@signnow.com | password |
    And I should receive an id

  Scenario: Creating another user with missing email
    Given I am an API user of SignNow
    When I try to create the user it should fail
      | first_name   | last_name   | email | password |
      | Test-First-# | Test-Last-# |       | password |

  Scenario: Creating another user with missing password
    Given I am an API user of SignNow
    When I try to create the user it should fail
      | first_name   | last_name   | email                 | password |
      | Test-First-# | Test-Last-# | test-user@signnow.com |          |
