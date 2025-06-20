@REQ_BDMNA-0001 @karate @BDMNA-0001
Feature: Character API Tests
  Background:
    * header Accept = 'application/json'
    * def devToUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def util = Java.type('util.Util')
    * def randomName = util.getRandomName()
    * def setup = callonce read('classpath:create-character.feature')
    * def globalCharacterId = setup.characterId


    @id:1 @CreateCharacterDuplicated
    Scenario:  T-API-BDMNA-0001-CAX-CreateCharacterDuplicated
      Given url devToUrl
      And header Content-Type = 'application/json'
      And request
        """
        {
          "name": "kcatucuamba",
          "alterego": "kcatucuamba",
          "description": "A genius programmer and a superhero",
          "powers": ["PHP", "JAVA"]
        }
        """
      When method post
      Then status 400
      * print response
      Then match response.error == 'Character name already exists'

  @id:2 @CreateCharacterFieldsEmpty
  Scenario:  T-API-BDMNA-0001-CAX-FieldsEmpty
    Given url devToUrl
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method post
    Then status 400
    * print response
    Then match response.name == 'Name is required'

  @id:3 @GetAllCharacters
  Scenario: T-API-BDMNA-0001-CAX-GetAllCharacters
    Given url devToUrl
    When method get
    Then status 200
    * print response
    Then match response == '#[]'
    Then assert response.length > 0

  @id:4 @GetCharacterByIdSuccess
  Scenario Outline: T-API-BDMNA-0001-CAX-GetCharacterByIdSuccess
    Given url devToUrl + '/' + characterId
    When method get
    Then status 200
    * print response
    * def characterIdNumber = +characterId
    Then match response.id == characterIdNumber
    Then match response.name != null
    Then match response.alterego != null
    Then match response.description != null
    Then match response.powers != null
    Examples:
      | characterId    |
      | 73             |

  @id:5 @GetCharacterByIdNotFound
  Scenario Outline: T-API-BDMNA-0001-CAX-GetCharacterByIdNotFound
    Given url devToUrl + '/' + characterId
    When method get
    Then status 404
    * print response
    Then match response.error == 'Character not found'
    Examples:
      | characterId    |
      | 0              |
      | -100           |

    @id:6 @UpdateCharacterSuccess
    Scenario Outline:  T-API-BDMNA-0001-CAX-UpdateCharacterSuccess
      Given url devToUrl + '/' + characterId
      And header Content-Type = 'application/json'
      And request
        """
        {
          "name": "kcatucuamba",
          "alterego": "kcatucuamba",
          "description": "A genius programmer and a superhero",
          "powers": ["PHP", "JAVA"]
        }
        """
      When method put
      Then status 200
      * print response
      Examples:
        | characterId    |
        | 73             |

  @id:7 @UpdateCharacterNotFound
  Scenario Outline:  T-API-BDMNA-0001-CAX-UpdateCharacterNotFound
    Given url devToUrl + '/' + characterId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "kcatucuamba",
        "alterego": "kcatucuamba",
        "description": "A genius programmer and a superhero",
        "powers": ["PHP", "JAVA"]
      }
      """
    When method put
    Then status 404
    * print response
    Then match response.error == 'Character not found'
    Examples:
      | characterId    |
      | 100001         |

  @id:8 @DeleteCharacterNotFound
  Scenario Outline:  T-API-BDMNA-0001-CAX-DeleteCharacterNotFound
    Given url devToUrl + '/' + characterId
    And header Content-Type = 'application/json'
    When method delete
    Then status 404
    * print response
    Then match response.error == 'Character not found'
    Examples:
      | characterId    |
      | 100001         |
      | 100002         |

  @id:9 @DeleteCharacterSuccess
  Scenario:  T-API-BDMNA-0001-CAX-DeleteCharacterSuccess
      * print 'El id global es:', globalCharacterId
      Given url devToUrl + '/' + globalCharacterId
      And header Content-Type = 'application/json'
      When method delete
      Then status 204
      * print response