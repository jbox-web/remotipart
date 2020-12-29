# frozen_string_literal: true

# Load Bundler
require_relative 'boot'

# Load Rails
require 'rails/all'

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

# Load tested lib
require 'jquery-rails'
require 'carrierwave'

module Dummy
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("..", "..", "vendor", "assets", "javascripts")
    config.active_record.time_zone_aware_types = [:datetime, :time]
    config.active_record.sqlite3.represent_boolean_as_integer = true if config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer=)
  end
end
