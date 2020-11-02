Feature: Chat core operations

  @c_chat @c_video_call
  Scenario: User can receive missed Video call message
    Given user with parameters
      | role            | name |
      | primary_user    | Dima |
      | video_call_user | Lera |
    And   primary_user logs in
    And   primary_user receives missed Video call from video_call_user via QaApi
    When  primary_user opens chat with video_call_user
    Then  primary_user should have missed Video call message from "Lera"

  @c_chat
  Scenario: Next batch of messages is loaded when user scroll up
    Given user with parameters
      | role         | gender | photos_count |
      | primary_user | male   | 1            |
    And   user with parameters
      | gender | name |
      | male   | Pram |
    And   primary_user receives the message "First Message - Stationery shop moves" from Pram via QaApi
    And   primary_user has quick chat with "Pram" via QaApi
    And   primary_user receives the message "hello" from Pram via QaApi 25 times
    And   primary_user receives the message "Final Message - see you!" from Pram via QaApi
    When  primary_user logs in
    And   primary_user goes to Connections page
    And   primary_user opens chat with Pram
    Then  primary_user verifies the chat message "Final Message - see you!" has been received
    When  primary_user sends the message "see you soon!"
    Then  "see you soon!" message should have status "Delivered"
    When  primary_user scrolls to top of conversation
    Then  primary_user verifies the chat message "First Message - Stationery shop moves" is the first message
    # INFO: Bad Practice
    # Example #4 - check that loader disappear using Poll.for_false.
    # In this case, polling can exit on the first iteration before loader appearing, but then loader can appear in 5 seconds later
    And   message loader should not appear within 10 seconds

  @c_chat @c_gif
  Scenario: User can search and send GIF message
    Given user with parameters
      | role            | name |
      | primary_user    | Dima |
      | chat_user       | Lera |
    And   primary_user logs in
    When  primary_user opens chat with chat_user
    And   primary_user switches to GIF input source
    And   primary_user stores the current list of GIFs
    And   primary_user searches for "bee" GIFs
    Then  primary_user verifies that list of GIFs is updated
    When  primary_user sends 2th GIF in the list
    Then  primary_user verifies that the selected GIF has been sent
