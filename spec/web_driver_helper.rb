# frozen_string_literal: true

require 'selenium/webdriver'
require 'chromedriver/helper'
require 'chromedriver-helper'

Capybara.register_driver :chrome do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile['download.default_directory'] = 'tmp/files'
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

  Capybara::Selenium::Driver.new app, browser: :chrome, profile: profile
end
Capybara.register_driver :chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[headless disable-gpu window-size=1920,1080 disable-dev-shm-usage no-sandbox],
      prefs: {
        'download.default_directory' => File.expand_path('tmp/files'),
        'download.prompt_for_download' => false,
        'browser.helperApps.neverAsk.saveToDisk' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      }
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end
Capybara.configure do |config|
  config.default_max_wait_time = 10 # seconds
  if ENV['ENABLE_BROWSER'] == 'true'
    config.default_driver = :chrome
    config.javascript_driver = :chrome
  else
    config.default_driver = :chrome_headless
    config.javascript_driver = :chrome_headless
  end
end
Chromedriver.set_version '2.46'
