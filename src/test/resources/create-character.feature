Feature: Create Character API Tests

  Background:
    * def devToUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def util = Java.type('util.Util')
    * def randomName = util.getRandomName()

  Scenario: Crear personaje y retornar id
    Given url devToUrl
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "#(randomName)",
        "alterego": "kcatucuamba",
        "description": "A genius programmer and a superhero",
        "powers": ["PHP", "JAVA"]
      }
      """
    When method post
    Then status 201
    * print response
    * def characterId = response.id