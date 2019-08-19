require 'simplecov'

# Start SimpleCov
SimpleCov.start do
  add_filter 'spec/'
end

# Load Rails dummy app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)

# Load test gems
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/cuprite'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

# Load our own config
require_relative 'config_capybara'
require_relative 'config_rspec'
