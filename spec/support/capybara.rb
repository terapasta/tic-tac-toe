require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => {
        args: %w(headless disable-gpu no-sandbox window-size=1680,1050),
      },
    )
  )
end

Capybara.javascript_driver = :selenium
