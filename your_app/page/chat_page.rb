require_relative '../component/chat'

module Pages
  class ChatPage < AbstractPage
    # INFO: Good Practice
    # Example 2 - extract components for Pages with rich UI to avoid God Object issue
    include Component::Chat::Toolbar
    include Component::Chat::Conversation
    include Component::Chat::InputSource

    def current_page?
      true # stub
    end

    # INFO: Bad Practice
    # Example #2 - put all the methods into the page
    #
    # def video_call_message_text; end
    # def call_back_button_text; end
    # def search_gifs; end
    # def tap_back_button; end
    # ...
    # all the rest 100+ methods
    #
    # endregion
  end
end