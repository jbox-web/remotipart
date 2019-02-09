# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy_app/config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'selenium-webdriver'

def register_driver(driver_name, args = [])
  Capybara.register_driver(driver_name) do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--window-size=1920,1200')
    args.each do |arg|
      options.add_argument(arg)
    end

    Capybara::Selenium::Driver.new(app,
      browser: :chrome,
      options: options
    )
  end
end

# Register our own custom drivers
register_driver(:chrome)
register_driver(:headless_chrome, %w[headless disable-gpu no-sandbox disable-dev-shm-usage])

# Configure Capybara JS driver
Capybara.current_driver    = :headless_chrome
Capybara.javascript_driver = :headless_chrome

# Configure Capybara server
Capybara.run_server = true
Capybara.server     = :puma, { Silent: true }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each {|f| require f }

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include RSpec::Matchers
  config.include Capybara::DSL, type: :feature
  config.include IntegrationHelper, type: :feature

  load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default

  config.order = :random
  Kernel.srand config.seed

  config.mock_with :rspec

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.use_transactional_fixtures = false

  config.fixture_path = File.expand_path('../fixtures', __FILE__)

  config.before do |example|
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
