# frozen_string_literal: true

# Configure RSpec
RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include RSpec::Matchers
  config.include Capybara::DSL, type: :feature
  config.include IntegrationHelper, type: :feature

  # Use DB agnostic schema by default
  load Rails.root.join('db', 'schema.rb').to_s

  # bin/rspec --seed 55420
  # Ambiguous match, found 2 elements matching visible link "Destroy" in
  # ./spec/remotipart/features/comments_spec.rb:56
  config.use_transactional_fixtures = true

  # Set our fixtures path
  config.fixture_paths = File.expand_path('fixtures', __dir__)

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

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
