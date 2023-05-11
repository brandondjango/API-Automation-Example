Feature: Dog Playground


  Scenario: Get specific breed image
    When the request is built for "breed/african/images/random"
    And the "get" request is sent

@only
  Scenario: List all breeds
    When the request is built for "breeds/list/all"
    And the "get" request is sent
    Then the response contains the key "beagle"
  Then the response contains the key "retriever" that contains the value "golden" within the value for that key
    Then the response contains the key "status" with the value "success"

