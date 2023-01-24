# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'karafka/backends/sidekiq'

Gem::Specification.new do |spec|
  spec.name        = 'karafka-sidekiq-backend'
  spec.version     = Karafka::Backends::Sidekiq::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Maciej Mensfeld']
  spec.email       = %w[maciej@mensfeld.pl]
  spec.homepage    = 'https://karafka.io'
  spec.summary     = 'Karafka Sidekiq backend for background messages processing'
  spec.description = 'Karafka Sidekiq backend for background messages processing'
  spec.license     = 'MIT'

  spec.add_dependency 'karafka', '~> 1.4.0'
  spec.add_dependency 'sidekiq', '>= 4.2'
  spec.required_ruby_version = '>= 2.7'

  if $PROGRAM_NAME.end_with?('gem')
    spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end

  spec.cert_chain    = %w[certs/mensfeld.pem]
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
  spec.post_install_message = <<~MSG
    WARN: Karafka Sidekiq Backend and Karafka 1.4 are no longer maintained.
    Karafka 2.0 is multi-threaded and does not need an alternative backend.
    We highly recommend updating to Karafka 2.0.
    Visit this page for more details: https://karafka.io/docs/Versions-Lifecycle-and-EOL
  MSG
  
  spec.metadata = {
    'funding_uri' => 'https://karafka.io/#become-pro',
    'homepage_uri' => 'https://karafka.io',
    'changelog_uri' => 'https://github.com/karafka/sidekiq-backend/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/karafka/sidekiq-backend/issues',
    'source_code_uri' => 'https://github.com/karafka/sidekiq-backend',
    'documentation_uri' => 'https://github.com/karafka/sidekiq-backend#readme',
    'rubygems_mfa_required' => 'true'
  }
end
