Feature: Get a signing link to a document
  In order to request that someone signs unsigned document
  As an API user of SignNow
  I want to generate a signing link


  Scenario: Generating a signing link
    Given I am an API user of SignNow
    And I have the users
      | first_name | last_name | email               | password |
      | Jean Luc   | Picard    | jeanluc@signnow.com | password |
      | Will       | Riker     | will@signnow.com    | password |
    And I generate their tokens
    And I have a document from file "features/support/test-form.pdf"
    And I have an invitation to the document for both users
    When I generate a signing link
    Then I should have a link to the document



