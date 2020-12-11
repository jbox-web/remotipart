RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include RSpec::Matchers
  config.include Capybara::DSL, type: :feature
  config.include IntegrationHelper, type: :feature

  # Use DB agnostic schema by default
  load Rails.root.join('db', 'schema.rb').to_s

  # Set our fixtures path
  config.fixture_path = File.expand_path('fixtures', __dir__)

  # Run tests in random order
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.around(:each) do |ex|
    ex.run_with_retry retry: 3
  end
end
