# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'karafka/backends/sidekiq'

Gem::Specification.new do |spec|
  spec.name        = 'karafka-sidekiq-backend'
  spec.version     = Karafka::Backends::Sidekiq::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Maciej Mensfeld']
  spec.email       = %w[maciej@coditsu.io]
  spec.homepage    = 'https://github.com/karafka/karafka-sidekiq-backend'
  spec.summary     = 'Karafka Sidekiq backend for background messages processing'
  spec.description = 'Karafka Sidekiq backend for background messages processing'
  spec.license     = 'MIT'

  spec.add_dependency 'activesupport', '>= 4.0'
  spec.add_dependency 'karafka', '~> 1.2'
  spec.add_dependency 'sidekiq', '>= 4.2'
  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
end
