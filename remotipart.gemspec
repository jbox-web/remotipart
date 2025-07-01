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

  s.required_ruby_version = '>= 3.2.0'

  s.files = Dir['README.md', 'CHANGELOG.md', 'LICENSE', 'lib/**/*.rb', 'vendor/**/*.js']

  s.add_dependency 'rails', '>= 7.0'
  s.add_dependency 'zeitwerk'
end
