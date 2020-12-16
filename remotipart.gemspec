# frozen_string_literal: true

require_relative 'lib/remotipart/version'

Gem::Specification.new do |s|
  s.name        = 'remotipart'
  s.version     = Remotipart::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Greg Leppert', 'Steve Schwartz', 'Nicolas Rodriguez']
  s.email       = ['greg@formasfunction.com', 'steve@alfajango.com', 'nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/remotipart'
  s.summary     = 'Remotipart is a Ruby on Rails gem enabling remote multipart forms (AJAX style file uploads) with jquery-rails.'
  s.description = 'This gem augments the native Rails jQuery UJS remote form function enabling asynchronous file uploads with little to no modification to your application.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'rails', '>= 5.1'
  s.add_runtime_dependency 'zeitwerk'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'cuprite'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'paperclip'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-retry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
  s.add_development_dependency 'sqlite3', '~> 1.4.0'
end
