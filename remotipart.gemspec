# frozen_string_literal: true

require_relative 'lib/remotipart/version'

Gem::Specification.new do |s|
  s.name        = 'remotipart'
  s.version     = Remotipart::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Greg Leppert', 'Steve Schwartz', 'Nicolas Rodriguez']
  s.email       = ['greg@formasfunction.com', 'steve@alfajango.com', 'nico@nicoladmin.fr']
  s.homepage    = 'https://github.com/jbox-web/remotipart'
  s.summary     = 'Remotipart is a Ruby on Rails gem enabling remote multipart forms (AJAX style file uploads) with jquery-rails.'
  s.description = 'This gem augments the native Rails jQuery UJS remote form function enabling asynchronous file uploads with little to no modification to your application.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.0.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'rails', '>= 6.1'
  s.add_runtime_dependency 'zeitwerk'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'carrierwave'
  s.add_development_dependency 'cuprite'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-retry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-capybara'
  s.add_development_dependency 'rubocop-rake'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3', '~> 1.4.0'

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1.0")
    s.add_development_dependency 'net-imap'
    s.add_development_dependency 'net-pop'
    s.add_development_dependency 'net-smtp'
  end

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
    s.add_development_dependency "base64"
    s.add_development_dependency "bigdecimal"
    s.add_development_dependency "mutex_m"
    s.add_development_dependency "drb"
    s.add_development_dependency "logger"
  end
end
