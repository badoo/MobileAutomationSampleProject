Feature: Registration Basic

  @c_registration @c_social_network
  Scenario: [Device Location OFF] Registration by Facebook
    Given user with parameters
      | role     | social_account |
      | new_user | Facebook       |
    And   Location Service is OFF on device
    And   application is started
    When  new_user registers account via Facebook
    And   new_user sets default location
    And   new_user dismisses Location Blocking page
    Then  new_user waits for Encounters page
