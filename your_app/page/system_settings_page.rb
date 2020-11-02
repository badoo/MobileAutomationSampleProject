module Pages
  class SystemSettingsPage < AbstractPage
    module UISwitch
      ON  = 'On'
      OFF = 'Off'
    end

    def current_page?
      true # stub
    end

    def ensure_location_service_is_off(switch: { type: 'Switch' })
      system_ui.wait_for_elements_displayed(switch)

      if system_ui.element_value(switch) == UISwitch::ON
        system_ui.tap_element(switch)
        system_ui.tap_element(id: 'Turn Off')

        # INFO: Good Practice
        # Example #5 - ensure the specific state for precondition action
        Poll.for(timeout_message: 'Location service should be disabled') do
          system_ui.element_value(switch) == UISwitch::OFF
        end
      end
    end

    # def ensure_location_service_in_state_off(switch: { type: 'Switch' })
    #   system_ui.wait_for_elements_displayed(switch)
    #
    #   if system_ui.element_value(switch) == UISwitch::ON
    #     system_ui.tap_element(switch)
    #     system_ui.tap_element(id: 'Turn Off')
    #
    #     # INFO: Bad Practice
    #     # Example #5 - no guarantee of async action to switch off location service
    #   end
    # end
  end
end