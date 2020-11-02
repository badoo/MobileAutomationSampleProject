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