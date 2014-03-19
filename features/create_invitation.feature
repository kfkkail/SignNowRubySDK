Feature: Create an invitation to a document
  In order to request a signature
  As an API user of SignNow
  I want to create a signing invitation

  Background:
    Given I am an API user of SignNow
    And I have the users
      | first_name | last_name | email               | password |
      | Jean Luc   | Picard    | jeanluc@signnow.com | password |
      | Will       | Riker     | will@signnow.com    | password |
    And I generate their tokens
    And I have a document from file "features/support/test-form.pdf"

  Scenario: Creating a free form signing invitation
    When I create an invitation to the document for both users
    Then I should have an invitation


  Scenario: Create a role based signing invitation
    When I add a text field to the document
      | x   | y  | width | height | page_number | label          | role    | required | type |
      | 307 | 67 | 60    | 12     | 0           | shoop da whoop | tatonka | true     | text |
    And I update the document
    And I create a role based invitation to the document for both users
    Then I should have an invitation