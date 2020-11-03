# Sample Project

The sample project demonstrates the best practices to reuse on mobile automation project on Ruby with Cucumber framework.

You can find each practice by keywords like: 'Good Practice' or 'Bad Practice'.
For example: 

Bad Practice #1

```ruby
# INFO: Bad Practice
# Example #1 - verification logic is moved to the Page
And(/^(.+) should have missed Video call message from "(.+)"$/) do |user, chat_companion_name|
  persona_with(role: user) do
    Pages::ChatPage.new.await.verify_missed_video_call(name: chat_companion_name)
  end
end
```

vs

Good Practice #1

```ruby
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
```

## Best Practices: Quick References

1.1. Keep verification logic in steps: 

* verification logic in steps - steps/chat_steps.rb:53
* keep page methods simple - your_app/component/chat/conversation/message/video_message.rb:10

1.2. Create components:

* video message chat component - your_app/component/chat/conversation/message/video_message.rb:11

1.3. Create generic steps

* generic page await - steps/generic_steps.rb:21
* generic go back action - steps/generic_steps.rb:29

1.4. Verify all possible states:

* loader should not appear - steps/chat_steps.rb:35

1.5. Create ensured preconditions

* ensure location service is off - your_app/page/system_settings_page.rb:20
* ensure all chat messages received - steps/chat_steps.rb:23
 
1.6. Create reusable and stable steps:

* create simple steps to reuse it in many cases - steps/chat_steps.rb:84
* create complex steps and ensure state transition inside - steps/chat_steps.rb:119

1.7. Verify optional elements:

* verify optional titles and buttons - your_app/page/abstract_alert_page.rb:10

## Environment Requisites

1.1. Install RVM:
```
curl -sSL https://get.rvm.io | bash -s stable
```
to start using RVM you need to run `source ~/.rvm/scripts/rvm`

1.2. Install Ruby:
```
rvm install ruby-2.6.3
```
1.3. Install Bundler Gem to manage Gem dependencies:
```
gem install bundler
```

1.4. Install Gem dependencies from Gemfile:
```
bundle install
```

## Usage

For running tests cases, please use command: 
```
bundle exec cucumber -p sample_project
```