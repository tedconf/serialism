# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'serialism/version'

Gem::Specification.new do |spec|
  spec.name          = 'serialism'
  spec.version       = Serialism::VERSION
  spec.authors       = ['Alex Dean']
  spec.email         = ['github@mostlyalex.com']
  spec.summary       = 'Like ActiveModel::Serializer but smaller and not JSON-centric.'
  spec.homepage      = 'https://github.com/tedconf/serialism'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'ruby_gntp'
  spec.add_development_dependency 'ci_reporter_rspec'
  spec.add_development_dependency 'brakeman'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-checkstyle_formatter'
end
