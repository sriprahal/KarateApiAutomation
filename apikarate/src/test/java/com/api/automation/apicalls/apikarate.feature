Feature: GET,POST,PUT,DELETE http methods and Negative scene

  Background: base url
    Given url 'https://gorest.co.in'

    * def token = '054e846a310b4fffb1e2c7e6d8a3753fce788478ad045f252605b9118bf8a7c7'

    #------------>function to generate a random 10 digit email<-------------
    * def random_string =
	"""
		function(s){
			var text = "";
			var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
			for(var i=0; i<s; i++)
				text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
				return text;
		}
	"""

    #------------> Creating variables<-----------
    * def randomEmail = random_string(10)
    * def body = read("data/jobData.json")
    * set body[0].email = randomEmail + "@gmail.com"
    * set body[1].email = randomEmail + "@gmail.com"
    * set body[2].email = randomEmail + "@gmail.com"
    * set body[3].email = randomEmail + "@gmail.com"
    * def postBody = body[0]
    * def putBody = body[1]
    * def deleteBody = body[2]
    * def negBody = body[3]

  Scenario: Performing GET request and getting data in JSON format
    Given path '/public/v2/users'
    And header Authorization = 'Bearer ' + token
    #---->GET call - getting the data
    When method get
    Then status 200
    And print response
        #asserting the get response
    And response.id = "#present"

  Scenario: Performing POST,PUT requests - creating & updating the data
    Given path "/public/v2/users"
    And request postBody
    And header Authorization = 'Bearer ' + token
    #---->POST call - creating a new data
    When method post
    Then status 201
    And print response
        #Asserting the post response
    And match response.id == '#present'
    And match response.email == body[0].email
    * def resIdMatch = read("data/JsonResponse.json")
    And match response.name == resIdMatch.name

    #---->PUT call - updating the created data
    * def userId = response.id
    Given path '/public/v2/users/' + userId
    And request putBody
    And header Authorization = 'Bearer ' + token
    When method put
    Then status 200
    And print response
        #Asserting the put response
    And match response.id == userId
    And match response.name == putBody.name
    And match response.gender == putBody.gender
    And match response.email == '#present'

    #---->DELETE call - deleting a created data
  Scenario: Deleting a created user
    Given path "/public/v2/users"
    And request deleteBody
    And header Authorization = 'Bearer ' + token
    When method post
    * def deleteUserId = response.id

    Given path "/public/v2/users/" + deleteUserId
    And header Authorization = 'Bearer ' + token
    When method delete
    Then status 204
        #Asserting the delete response
    And print response
    And match response.message == null


    #---------Validating Negative Scenarios ---------

  @First-negScene
  Scenario: Creating a data without header
    Given path "/public/v2/users"
    And request negBody
    When method post
    Then status 401
        #validating the error code
    And print response
    * def id = response.id
    And match response.message == "Authentication failed"

  @Second-negScene
  Scenario: Trying to fetch the deleted data

        #passing variable from another scenario
    * call read('apikarate.feature@First-negScene')

    Given path "/public/v2/users/" + id
    And header Authorization = 'Bearer ' + token
    When method delete

    Given path "/public/v2/users/" + id
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 404
        #validating the error code
    And print response
    And match response.message == "Resource not found"













