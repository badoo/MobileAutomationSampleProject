require_relative 'conversation/message/video_message'
require_relative 'conversation/animation'

module Component
  module Chat
    module Conversation
      include Message::Video
      # include Message::Audio
      # include Message::AnyOtherType

      include Animation
    end
  end
end
