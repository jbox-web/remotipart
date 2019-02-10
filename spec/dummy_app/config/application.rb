require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'jquery-rails'
require 'paperclip'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DummyApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    config.assets.paths << Rails.root.join("..", "..", "vendor", "assets", "javascripts")
    config.active_record.time_zone_aware_types = [:datetime, :time]
    config.active_record.sqlite3.represent_boolean_as_integer = true if config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer=)
  end
end
