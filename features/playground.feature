@brief-bibs @solr @wip
Feature: Playground

  Background:
    And I add the header parameter hash string with key "wskey" and key/value pairs:
      | key             | value      |
      | context_id      | 128807     |
      | context_id_type | registryId |


  Scenario: play
    When the request is built for "institutions"
    And I add the parameter "institutionType" with value "regional_or_national"
    And I add the parameter "lat" with value "40.1"
    And I add the parameter "lon" with value "-83.1"
    And I add the parameter "distance" with value "99999"
    And the "get" request is sent

  Scenario: bibs-syndicated holdings heldInCountry - US
    When the request is built for "e-holdings"
   # And I add the parameter "oclcSymbol" with value "OCWMS"
    And I add the parameter "registryId" with value "91475"
    And I add the parameter "oclcNumber" with value "184476"
    And the "get" request is sent


  Scenario: Custom link
    When the request is built for "local-services-links"
    And I add the parameter "registryId" with value "129026"
    And I add the parameter "oclcNumber" with value "351312848"
    And the "get" request is sent
    Then the response contains the key "institutionName" that contains the value "TEST OHIO STATE UNIV THE" within the value for that key
    Then the response contains the key "url" that contains the value "http://proxy.lib.ohio-state.edu/" within the value for that key

  Scenario: Validate happy path bibs opac - issn
    When the request is built for "bibs-opac-link"
    And I add the parameter "registryId" with value "129026"
    And I add the parameter "oclcNumber" with value "351312848"
    And the "get" request is sent



  Scenario: Bibs parameter groupRelatedEditions - present
    Given the request is built for "summary-bibs?q=wood&groupRelatedEditions=true&preferredLanguage=eng&limit=10&offset=1&orderBy=library&lat=40.1117&lon=-82.9728&distance=100&unit=M&relevanceByGeoCoordinates=true"
    #And I add the parameter "q" with value "weather"
    #And I add the parameter "lat" with value "40"
    #And I add the parameter "lon" with value "-83"
    #And I add the parameter "unit" with value "M"
    #And I add the parameter "distance" with value "100"
    When the "get" request is sent
    #And the response contains the key "editionCluster"
    #And the response contains the key "totalEditions"
    #And the response contains a hash from key "editionCluster" with key "id"
    #And the response contains a hash from key "editionCluster" with key "count"


  Scenario: Validate happy path other-editions - orderBy library
    When the request is built for "detailed-bibs"
    And I iterate through oclc numbers starting with "958074206" until I find one with a key "source" with a value "bibrec-901"


  Scenario: Validate happy path other-editions - orderBy library
    When the request is built for "detailed-bibs/958074206"
    When the "get" request is sent

     #DA-54845

  Scenario: X-OCLC-DataSource-Debug Header - institutions - Library View present
    When the request is built for "institutions/549"
    And I add the header parameter "X-OCLC-DataSource-Debug" with value "true"
    And the "get" request is sent


  Scenario: X-OCLC-Visibility - false
    When the request is built for "institutions"
    And I add the parameter "registryIds" with value "2135"
    And I add the header parameter "X-OCLC-Visibility" with value "false"
    And the "get" request is sent
    Then the response contains the key "id"
    Then the header response does not contain the key "x_oclc_datasourceurl" that contains the value "local.WCVisible" within the value for that key


  Scenario: geoRelevance X-OCLC-Relevancy-Config - rankingInstitution on - summary-bibs
    When the request is built for "summary-bibs?q=weather&preferredLanguage=eng&limit=10&offset=1&orderBy=library&lat=40.1117&lon=-82.9728&relevanceByGeoCoordinates=true"
    And I add the header parameter hash string with key "wskey" and key/value pairs:
      | key             | value      |
      | context_id      | 128807     |
      | context_id_type | registryId |
    And the "get" request is sent
    #Then the header response contains the key "x_oclc_datasourceurl" that contains the value "&x-info-5-rankingGroup=gc15955,gs58,gn111&" within the value for that key
    #Then the header response contains the key "x_oclc_datasourceurl" that contains the value "&x-info-5-rankingInstitution=63416&" within the value for that key


  @accessOptions
  Scenario: Validate happy path e-holdings - oclcNumber
    When the request is built for "summary-bibs?q=harry%20potter&groupRelatedEditions=true&preferredLanguage=eng&facets=audience,content,creator,datePublished,itemSubType,itemType,language,topic"
    And the "get" request is sent
    #Then the response contains the key "url" that contains the value "link.worldcat-m1.dev.oclc.org" within the value for that key

  Scenario: Validate facets - topic
    When the request is built for "summary-bibs?q=Da%20Vinci%20Code%20dan%20brown&audience=&author=&content=&datePublished=&inLanguage=&itemSubType=&itemType=&limit=10&offset=1&openAccess="
    And the "get" request is sent

  @accessOptions
  Scenario: Validate X-OCLC-Visibility header - true
    When the request is built for "e-holdings?oclcSymbol=CPE&registryId=366&oclcNumber=818677644"
    And the "get" request is sent
    Then the response does not contain the key "registryId"

  Scenario: Verify retained-holdings end point returns totalHoldingCount and detailedHoldings array with member holding data
    Given the request is built for "retained-holdings?oclcNumber=111111111111&heldBySymbol=EMU "
    And I add the header parameter hash string with key "wskey" and key/value pairs:
      | key             | value      |
      | context_id      | 128807     |
      | context_id_type | registryId |
    And I add the header parameter "X-OCLC-Relevancy-Config" with value "custom"
    And the "get" request is sent


  Scenario: add relationship element to includes - lookup
    When the request is built for "detailed-bibs/927457034"
    And the "get" request is sent

    #
# http://eusap13dxdu.dev.oclc.org:8080/discovery/worldcat/v1/detailed-bibs/958074205

# while loop



# http://eusap13dxdu.dev.oclc.org:8080/discovery/worldcat/v1/detailed-bibs/958074206

# while loop



# http://eusap13dxdu.dev.oclc.org:8080/discovery/worldcat/v1/detailed-bibs/958074207
