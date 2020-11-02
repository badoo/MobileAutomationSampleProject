module Poll
  class WaitError < RuntimeError
  end

  # Polls for a condition to be true. This is intended to replace MOST instances of wait_for,
  # where the interrupting time-out behaviour is excessive in comparison to its danger.
  #
  # The condition is specified by a given block that is called repeatedly.
  # If the block returns a 'trueish' value the condition is considered true and
  # `Poll.for` immediately returns.
  #
  # There is a `:timeout` option that specifies a maximum number of seconds to wait.
  # If the given block doesn't return a 'trueish' value before the `:timeout` seconds has elapsed,
  # a timeout exception `Poll::WaitError` will be raised.
  #
  # If `:return_on_timeout` is true, result will be returned instead of timeout exception.
  def self.for(timeout: Wait::DEFAULT_TIMEOUT, retry_interval: Wait::RETRY_INTERVAL, timeout_message: "Poll.for condition is FAIL.", return_on_timeout: false)
    # INFO: Guard Checks for parameters validation because "all as Object" nature of Ruby
    Assertions.assert_true(block_given?, "Code block for Poll.for function should be defined")
    Assertions.assert_true(timeout.is_a?(Integer) && timeout.positive?, "Parameter timeout should be Integer value greater than 0. Actual: #{timeout}")
    Assertions.assert_true(retry_interval.is_a?(Float) && retry_interval.positive? && retry_interval < timeout, "Parameter retry_interval should be greater than 0 and less than timeout. Actual: #{retry_interval}")
    Assertions.assert_true(timeout_message.is_a?(String) && !timeout_message.empty?, "Parameter timeout_message should be non empty String. Actual: #{timeout_message}")
    Assertions.assert_true(return_on_timeout.is_a?(TrueClass) || return_on_timeout.is_a?(FalseClass), "Parameter return_on_timeout should be boolean. Actual: #{return_on_timeout}")

    result = nil

    start  = Time.now
    now    = start
    finish = start + timeout

    while now < finish
      result = yield
      puts "      [Poll] result = #{result}, time: #{now}"

      break if result.is_a?(TrueClass)

      sleep(retry_interval)
      now = Time.now
    end

    return result if return_on_timeout || result.is_a?(TrueClass)

    elapsed = (now.to_f - start.to_f).to_i
    raise(Poll::WaitError, "#{timeout_message} (was waiting for #{elapsed} seconds)")
  end

  def self.for_match(expected, timeout: Wait::DEFAULT_TIMEOUT, retry_interval: Wait::RETRY_INTERVAL, timeout_message: "Poll.for_match condition is FAIL.")
    self.for(timeout: timeout, retry_interval: retry_interval, timeout_message: timeout_message) do
      actual = yield
      actual.is_a?(String) && expected.match?(actual)
    end
  end

  def self.for_equal(expected, timeout: Wait::DEFAULT_TIMEOUT, retry_interval: Wait::RETRY_INTERVAL, timeout_message: "Poll.for_equal condition is FAIL.")
    self.for(timeout: timeout, retry_interval: retry_interval, timeout_message: timeout_message) do
      actual = yield
      actual == expected
    end
  end

  def self.for_true(timeout: Wait::DEFAULT_TIMEOUT, retry_interval: Wait::RETRY_INTERVAL, timeout_message: "Poll.for_true condition is FAIL.")
    self.for(timeout: timeout, retry_interval: retry_interval, timeout_message: timeout_message) do
      actual = yield
      actual.is_a?(TrueClass)
    end
  end

  def self.for_false(timeout: Wait::DEFAULT_TIMEOUT, retry_interval: Wait::RETRY_INTERVAL, timeout_message: "Poll.for_false condition is FAIL.")
    self.for(timeout: timeout, retry_interval: retry_interval, timeout_message: timeout_message) do
      actual = yield
      actual.is_a?(FalseClass)
    end
  end
end
