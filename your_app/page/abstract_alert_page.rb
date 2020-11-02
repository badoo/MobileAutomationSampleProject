module Pages
  class AbstractAlertPage < AbstractPage
    TITLE   = "Some Locator"
    MESSAGE = "Some Locator"

    FIRST_BUTTON = "Some Locator index:0"
    LAST_BUTTON  = "Some Locator index:1"

    # INFO: Good Practice
    # Example #7 - use full system checks to verify optional elements
    def verify_alert(title: nil, description:, first_button:, last_button: nil)
      ui.wait_for_elements_displayed(MESSAGE, FIRST_ALERT_BUTTON)

      ui.wait_for_optional_element_text(expected_lexeme: title, locator: TITLE)
      ui.wait_for_element_text(expected_lexeme: description, locator: MESSAGE)
      ui.wait_for_element_text(expected_lexeme: first_button, locator: FIRST_BUTTON)
      ui.wait_for_optional_element_text(expected_lexeme: last_button, locator: LAST_BUTTON)
    end

    # INFO: Bad Practice
    # Example #7 - skip to check optional elements
    # def verify_alert(title: nil, description:, first_button:, last_button: nil)
    #   ui.wait_for_elements_displayed(MESSAGE, FIRST_ALERT_BUTTON)
    #
    #   ui.wait_for_element_text(expected_lexeme: title, locator: TITLE) if title
    #   ui.wait_for_element_text(expected_lexeme: description, locator: MESSAGE)
    #   ui.wait_for_element_text(expected_lexeme: first_button, locator: FIRST_BUTTON)
    #   ui.wait_for_element_text(expected_lexeme: last_button, locator: LAST_BUTTON) if last_button
    # end
  end
end
