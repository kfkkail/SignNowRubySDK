Feature: Create a document
  In order to manage documents with eSignatures
  As an API user of SignNow
  I want to create a document

  Scenario: Creating a document on SignNow
    Given I am an API user of SignNow
    And I have the user
      | first_name | last_name | email | password |
      | Laura  | Rosolin | laura@signnow.com | password|
    And I generate their tokens
    When I create a document from file "features/support/test-form.pdf"
    Then I will receive a document id