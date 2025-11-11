# frozen_string_literal: true

# Load ruby-warning gem
require 'warning'

Warning[:deprecated]   = true
Warning[:experimental] = true
Warning[:performance]  = true if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3.0')

# Ignore all warnings in Gem dependencies
Gem.path.each do |path|
  Warning.ignore(//, path)
end

# Load simplecov
require 'simplecov'
require 'simplecov_json_formatter'

# Start SimpleCov
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter])
  add_filter 'spec/'
end

# Load Rails dummy app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)

# Load test gems
require 'rspec/rails'
require 'capybara/cuprite'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

# Load our own config
require_relative 'config_capybara'
require_relative 'config_rspec'

if Rails.version >= '7.2'
  def fixture_path
    fixture_paths
  end
end
