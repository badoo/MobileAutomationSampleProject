# def send_message(from:, to:, message:, count:)
#   actual_messages_count   = QaApi.received_messages_count(to, from)
#   expected_messages_count = actual_messages_count + count
#
#   count.times do
#     QaApi.chat_send_message(user_id: from, contact_user_id: to, message: message)
#   end
#
#   # INFO: Bad Practice
#   # Example #5 - no guarantee all messages received to user
# end

def send_message(from:, to:, message:, count:)
  actual_messages_count   = QaApi.received_messages_count(to, from)
  expected_messages_count = actual_messages_count + count

  count.times do
    QaApi.chat_send_message(user_id: from, contact_user_id: to, message: message)
  end

  # INFO: Good Practice
  # Example #5 - ensure all messages received to user
  QaApi.wait_for_user_received_messages(from, to, expected_messages_count)
end

Then(/^(.+) receives? the message "(.+)" from (.+) via QaApi(?: (\d+) times?)?$/) do |message_receiver, message_content, message_sender, count|
  sender   = user_with_role_or_name(message_sender)
  receiver = user_with_role_or_name(message_receiver)
  count = count&.to_i || 1

  send_message(from: sender, to: receiver, message: message_content, count: count)
end

# INFO: Good Practice
# Example #4 - use full system checks to verify all possible state change combinations
And(/^message loader (should not appear|should appear) within (\d+) seconds$/) do |state, timeout|
  chat_page = Pages::ChatPage.new.await

  verify_dynamic_state(state: state, timeout: timeout.to_i, error_message: "Message loader #{state} within #{timeout} seconds.") do
    chat_page.loader_displayed?
  end
end

# INFO: Bad Practice
# Example #1 - verification logic is moved to the Page
# And(/^(.+) should have missed Video call message from "(.+)"$/) do |user, chat_companion_name|
#   persona_with(role: user) do
#     Pages::ChatPage.new.await.verify_missed_video_call(name: chat_companion_name)
#   end
# end

# INFO: Good Practice
# Example #1 - verification logic is moved to the step
And(/^(.+) should have missed Video call message from "(.+)"$/) do |user, chat_companion_name|
  persona_with(role: user) do
    chat_page = Pages::ChatPage.new.await

    # Check #1: Verify missed Video call message text
    expected = ExpectedData.missed_video_call(name: chat_companion_name)
    actual   = chat_page.video_call_message_text
    Assertions.assert_equal(expected, actual, "Missed video call message is incorrect")

    # Check #2: Verify missed Video call button
    expected = ExpectedData::CALL_BACK_BUTTON
    actual   = chat_page.call_back_button_text
    Assertions.assert_equal(expected, actual, "Call back button text is incorrect")
  end
end

# INFO: Bad Practice
# Example #6 - extract complicated step which is used only in one case
# And(/^(.+) searches for "(.+)" GIFs$/) do |user, keyword|
#   persona_with(role: user) do
#     chat_page = Pages::ChatPage.new.await
#     TestData.gif_list = chat_page.gif_list
#     chat_page.search_for_gifs(keyword)
#     Poll.for_true(timeout_message: 'Gif list should be updated') do
#       (TestData.gif_list & chat_page.gif_list).empty?
#     end
#   end
# end

# region: Good Practice
# Example #6 - extract independent simple steps to reuse it in many cases
And(/^(.+) searches for "(.+)" GIFs$/) do |user, keyword|
  persona_with(role: user) do
    Pages::ChatPage.new.await.search_for_gifs(keyword)
  end
end

And(/^(.+) stores the current list of GIFs$/) do |user|
  persona_with(role: user) do
    TestData.gif_list = Pages::ChatPage.new.await.gif_list
  end
end

And(/^(.+) verifies that list of GIFs is updated$/) do |user|
  persona_with(role: user) do
    chat_page = Pages::ChatPage.new.await
    Poll.for_true(timeout_message: 'Gif list should be updated') do
      (TestData.gif_list & chat_page.gif_list).empty?
    end
  end
end
# endregion

# INFO: Bad Practice
# Example #6 - no guarantee for state transitions during some actions
# When(/^primary_user votes No awaiting next profile in Messenger mini game (\d+) times?$/) do |count|
#   page = Pages::MessengerMiniGamePage.new.await
#
#   count.to_i.times do
#     page.vote_no
#   end
# end


# INFO: Good Practice
# Example #6 - ensure state transitions during some actions
When(/^primary_user votes No awaiting next profile in Messenger mini game (\d+) times?$/) do |count|
  page = Pages::MessengerMiniGamePage.new.await

  count.to_i.times do
    progress_before = page.progress
    page.vote_no
    Poll.for_true do
      page.progress > progress_before
    end
  end
end

And(/^(.+) verifies that the selected GIF has been sent$/) do |user|
  # stub
end

And(/^(.+) sends? (\d+)(?:th|nd|st) GIF in the list$/) do |user, gif_index|
  # stub
end

And(/^(.+) switches? to GIF input source$/) do |user|
  # stub
end

And(/^(.+) receives? missed Video call from (.+) via QaApi$/) do |user, chat_companion|
  # stub
end

And(/^(.+) (?:have|has) quick chat with "(.+)" via QaApi$/) do |user, chat_companion|
  # stub
end

And(/^(.+) sends? the message "(.+)"$/) do |user, message_text|
  # stub
end

Then(/^(.+) verif(?:y|ies) the chat message "(.+)" has been received$/) do |user, message|
  # stub
end

And(/^"(.+)" message should have status "(.+)"$/) do |message, status|
  # stub
end

And(/^(.+) scrolls? to top of conversation$/) do |user|
  # stub
end

And(/^(.+) verif(?:y|ies) the chat message "(.+)" is the first message$/) do |user, message|
  # stub
end
