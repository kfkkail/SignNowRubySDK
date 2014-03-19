Feature: Update a document
  In order to make a document interesting
  As an API user of SignNow
  I want to add add fields to the document

  Scenario: Adding a text field to a document
    Given I am an API user of SignNow
    And I have the user
      | first_name | last_name | email            | password |
      | Bill       | Adama     | bill@signnow.com | password |
    And I generate their tokens
    And I have a document from file "features/support/test-form.pdf"
    When I add a text field to the document
      | x   | y  | width | height | page_number | label          | role    | required | type |
      | 307 | 67 | 60    | 12     | 0           | shoop da whoop | tatonka | true     | text |
    And I update the document
    Then I should have that field in the document