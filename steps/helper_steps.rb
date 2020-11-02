def page_object_by(page_name)
  page_class = "#{page_name} page".downcase.split(' ').collect(&:capitalize).join

  return Pages.const_get(page_class).new if Pages.const_defined?(page_class)

  raise(NameError, "Can not construct page object for unknown class #{page_class}. Actual page name: '#{page_name}'")
end

# INFO: This method implemented for verification of dynamic states of elements:
# 1 - should appear
# 2 - should disappear
# 3 - should not appear
# 4 - should not disappear
#
# Example:
# page = Pages::ChatPage.new.await
# verify_dynamic_state(state: 'should appear', error_message: 'Error message') { page.audio_recording_tooltip_displayed? }
#
# @param [String] state - expected element state. For example state = 'should disappear'.
# @param [Integer] timeout - validation time. The timeout is not mandatory
# if it has not been passed the method will use a default one - Wait::SMALL.
# @param [String] error_message - message which user should see in case of failed check.
# @param [Proc] block — custom condition to verify an element state. Do not pass blocks with negates.
def verify_dynamic_state(state:, timeout: Wait::VERIFICATION_TIMEOUT, error_message:)
  Assertions.assert_not_nil(error_message, "Error message can not be nil, please specify it")

  options = {
    return_on_timeout: true,
    timeout:           timeout,
    timeout_message:   error_message,
    retry_interval:    Wait::RETRY_INTERVAL
  }

  start = Time.now
  error_message_block = -> { error_message += " Actual elapsed time: #{Time.now - start}" }

  # INFO: Good Practice
  # Example #4 - use full system checks to verify all possible state change combinations
  case state
    when 'should appear'
      actual_state = Poll.for(options) { guard_checked_boolean_result { yield } }
      Assertions.assert_true(actual_state, error_message_block.call)
    when 'should disappear'
      actual_state = Poll.for(options) { !guard_checked_boolean_result { yield } }
      Assertions.assert_true(actual_state, error_message_block.call)
    when 'should not appear'
      actual_state = Poll.for(options) { guard_checked_boolean_result { yield } }
      Assertions.assert_false(actual_state, error_message_block.call)
    when 'should not disappear'
      actual_state = Poll.for(options) { !guard_checked_boolean_result { yield } }
      Assertions.assert_false(actual_state, error_message_block.call)
    else
      raise("Undefined state: #{state}")
  end
end

def guard_checked_boolean_result
  block_result = yield

  if block_result.is_a?(TrueClass) || block_result.is_a?(FalseClass)
    block_result
  else
    raise("Passed block should return Boolean, but returns #{block_result.class}")
  end
end

def persona_with(role:)
  # stub
  yield
end

def user_with_role_or_name(role_or_name)
  # stub
end
