Feature: Validating the GET request from the file

  Background: base url
    Given url 'http://localhost:9897'

  Scenario: Performing GET request and validating data from the file
    Given path '/normal/webapi/all'
    When method get
    Then status 200
    * def actualResponse = read("data/JsonResponse.json")
    And match response == actualResponse
