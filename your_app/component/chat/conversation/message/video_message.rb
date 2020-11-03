module Component
  module Chat
    module Conversation
      module Message
        module Video
          VIDEO_CALL_MESSAGE = "Some Element ID #1"
          CALL_BACK_BUTTON   = "Some Element ID #2"

          # INFO: Good Practice
          # Example 1 - keep Page methods simple
          # Example 2 - extract Page methods into components
          def video_call_message_text
            ui.element_text(VIDEO_CALL_MESSAGE)
          end

          def call_back_button_text
            ui.element_text(CALL_BACK_BUTTON)
          end

          # INFO: Bad Practice
          # Example 1 - keep Page methods complicated (for example, with checking logic)
          # def verify_missed_video_call(name)
          #   expected = ExpectedData.missed_video_call(name: name)
          #   actual   = ui.element_text(VIDEO_CALL_MESSAGE)
          #   Assertions.assert_equal(expected, actual, "Missed video call message is incorrect")
          #
          #   expected = ExpectedData::CALL_BACK_BUTTON
          #   actual   = ui.element_text(CALL_BACK_BUTTON)
          #   Assertions.assert_equal(expected, actual, "Call back button text is incorrect")
          # end
        end
      end
    end
  end
end
