require 'test_helper'
require 'selenium/webdriver'

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :headless_chrome, using: :chrome, screen_size: [1400, 1400]
end
