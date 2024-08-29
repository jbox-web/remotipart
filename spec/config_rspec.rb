# Configure RSpec
RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include RSpec::Matchers
  config.include Capybara::DSL, type: :feature
  config.include IntegrationHelper, type: :feature

  # Use DB agnostic schema by default
  load Rails.root.join('db', 'schema.rb').to_s

  # Set our fixtures path
  if Rails.version >= '7.2'
    config.fixture_paths = File.expand_path('fixtures', __dir__)
  else
    config.fixture_path = File.expand_path('fixtures', __dir__)
  end

  # Run tests in random order
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  if ENV.key?('GITHUB_ACTIONS')
    config.around(:each) do |ex|
      ex.run_with_retry retry: 3
    end
  end
end
