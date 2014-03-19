Feature: Get a document
  In order to view a document owned by a user
  As an API user of SignNow
  I want to retrieve that document


  Scenario: Getting a document owned by a user
    Given I am an API user of SignNow
    And I have the user
      | first_name | last_name | email             | password |
      | Gaius      | Baltar    | gaius@signnow.com | password |
    And I generate their tokens
    And I have a document from file "features/support/test-form.pdf"
    When I get that document
    Then I should receive a document


  Scenario: Getting a document owned by a user
    Given I am an API user of SignNow
    And I have the user
      | first_name | last_name | email             | password |
      | Gaius      | Baltar    | gaius@signnow.com | password |
    And I generate their tokens
    And I have a document from file "features/support/test-form.pdf"
    When I download that document
    Then I should receive a file