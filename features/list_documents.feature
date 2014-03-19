Feature: Get documents
  In order to know what documents belong to me
  As an API user of SignNow
  I want to retrieve a list of documents


  Scenario: Getting list of owned documents
    Given I am an API user of SignNow
    And I have the user
      | first_name | last_name | email | password |
      | Gaius  | Baltar | gaius@signnow.com | password|
    And I generate their tokens
    And I have a document from file "features/support/test-form.pdf"
    And I have a document from file "features/support/test-form-2.pdf"
    When I get get a list of documents
    Then I should get a list of those documents

  Scenario: Getting status of all owned documents

  Scenario: Getting field-entered text data from all owned documents