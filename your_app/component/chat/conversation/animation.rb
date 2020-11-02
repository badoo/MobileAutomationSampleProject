module Component
  module Chat
    module Conversation
      module Animation
        # INFO: Small tweaks to hack loader to appear in 5 seconds
        @@dynamic_value = false

        def initialize
          Thread.new do
            sleep 5
            puts "      [ChatPage] loader appears!"
            @@dynamic_value = true
          end
        end

        def loader_displayed?
          puts "      [ChatPage] loader status: #{@@dynamic_value}"
          @@dynamic_value
        end
      end
    end
  end
end
