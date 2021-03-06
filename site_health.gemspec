# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'site_health/version'

Gem::Specification.new do |spec|
  spec.name          = 'site_health'
  spec.version       = SiteHealth::VERSION
  spec.authors       = ['Jacob Burenstam']
  spec.email         = ['burenstam@gmail.com']

  spec.summary       = 'Crawl a site and check various health indicators.'
  spec.description   = 'Crawl a site and check various health indicators, such as: HTTP 4XX, 5XX status, valid HTML/XML/JSON. Missing image alt attributes/missing HTML title/description.'
  spec.homepage      = 'https://github.com/buren/site_health'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'spidr', '~> 0.6'

  # Optional runtime dependencies
  spec.add_development_dependency 'google-api-client', '~> 0.19'
  spec.add_development_dependency 'html-proofer', '~> 3.8'
  spec.add_development_dependency 'w3c_validators', '~> 1.3'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '0.14.1'
  spec.add_development_dependency 'timecop', '~> 0.9'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.3'
end
