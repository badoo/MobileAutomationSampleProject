And(/^application is started$/) do
  # stub
end

And(/^System Settings app is killed$/) do
  # stub
end

And(/^Location Service is OFF on device$/) do
  Pages::SystemSettingsPage.new.await.ensure_location_service_is_off
end

And(/^network connection is (enabled|disabled) via backdoor$/) do
  # stub
end
