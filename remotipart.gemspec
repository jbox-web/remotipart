# frozen_string_literal: true

require_relative 'lib/remotipart/rails/version'

Gem::Specification.new do |s|
  s.name        = 'remotipart'
  s.version     = Remotipart::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Greg Leppert', 'Steve Schwartz']
  s.email       = ['greg@formasfunction.com', 'steve@alfajango.com']
  s.homepage    = 'https://github.com/jbox-web/remotipart'
  s.summary     = 'Remotipart is a Ruby on Rails gem enabling remote multipart forms (AJAX style file uploads) with jquery-rails.'
  s.description = 'This gem augments the native Rails jQuery UJS remote form function enabling asynchronous file uploads with little to no modification to your application.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.4.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'rails', '>= 5.0'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'chromedriver-helper'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'paperclip'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3', '~> 1.3.0'
end
