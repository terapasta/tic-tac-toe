require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => {
        args: %w(
          headless
          disable-gpu
          no-sandbox
          disable-popup-blocking
          window-size=1680,1050
        ),
      },
    )
  )
end

Capybara.javascript_driver = :selenium

module CapybaraHelpers
  def fill_in_input(id: nil, name: nil, selector: nil, value:)
    find_script = if id.present?
      "document.getElementById('#{id}')"
    elsif name.present?
      "document.querySelector('[name=\"#{name}\"]')"
    elsif selector.present?
      "document.querySelector('#{selector}')"
    end

    script = %Q{
      (function() {
        var target = #{find_script};
        target.value = '#{value}';
        var event = document.createEvent('Events');
        event.initEvent('input', true, true);
        target.dispatchEvent(event);
      })();
    }

    page.execute_script(script)
  end
end
