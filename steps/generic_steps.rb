# INFO: Bad Practice
# Example #3 - create many basic steps
# Then(/^primary_user wait for Chat page$/) do
#   Pages::ChatPage.new.await
# end
#
# Then(/^primary_user is on Encounters page$/) do
#   Pages::ChatPage.new.await
# end
#
# Then(/^primary_user returns from Encounters page$/) do
#   Pages::ChatPage.new.await.go_back
# end
#
# Then(/^primary_user taps back on Connections page$/) do
#   Pages::ChatPage.new.await.tap_back
# end


# INFO: Good Practice
# Example #3 - create generic step for basic actions like "Page await"
Then(/^(.+) waits? for (.+) page$/) do |user, page_name|
  persona_with(role: user) do
    page_object_by(page_name).await
  end
end

# INFO: Good Practice
# Example #3 - create generic step for basic actions like "go back"
And(/^(.+) (?:go|goes|) back from (.+) page$/) do |user, page_name|
  persona_with(role: user) do
    page_object_by(page_name).await.tap_back_button
  end
end
