module Pages
  class AbstractPage
    def current_page?
      raise "Not implemented"
    end

    def await
      Poll.for_true(timeout_message: "Incorrect page transition. Should open the page: #{self.class.name}") { current_page? }
      self
    end

    protected def ui
      @ui ||= UIOperations.new
    end

    protected def system_ui
      @system_ui ||= SystemUIOperations.new
    end
  end
end

class UIOperations
  # INFO: Good Practice
  # Example #7 - use full system checks to verify optional elements
  def wait_for_optional_element_text(expected_lexeme:, locator:)
    Assertions.assert_not_nil(locator, 'locator should be specified')

    if expected_lexeme.nil?
      Assertions.assert_false(elements_displayed?(locator), "Element '#{locator}' should not be displayed")
    else
      wait_for_element_text(expected_lexeme: expected_lexeme, locator: locator)
    end
  end

  # INFO: Expected lexeme can be Regex or String
  # Examples:
  # 1. Wait for reply alert:
  #
  #  module WaitForReply
  #    TITLE        = 'Wait for a reply'
  #    DESCRIPTION  = /You can not send any more messages to .* until .* replies/
  #    CLOSE_BUTTON = 'Close'
  #  end
  #
  # - wait_for_element_text(expected_lexeme: WaitForReply::TITLE, locator: title_locator)
  # - wait_for_element_text(expected_lexeme: WaitForReply::DESCRIPTION, locator: description_locator)
  def wait_for_element_text(expected_lexeme:, locator:, timeout_message: "Text of element '#{locator}' should be correct")
    if expected_lexeme.is_a?(Regexp)
      Poll.for_match(expected_lexeme, timeout_message: timeout_message) { element_text(locator) }
    else
      Poll.for_equal(expected_lexeme, timeout_message: timeout_message) { element_text(locator) }
    end
  end

  def method_missing(m, *args, &block)
    puts "      [STUB] any UI operation method call. Actual method: #{m}"
  end
end

class SystemUIOperations
  def method_missing(m, *args, &block)
    puts "      [STUB] any System UI operation method call. Actual method: #{m}"
  end
end
