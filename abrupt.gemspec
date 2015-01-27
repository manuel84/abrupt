# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abrupt/version'

Gem::Specification.new do |spec|
  spec.name = 'abrupt'
  spec.version = Abrupt::VERSION
  spec.authors = ['Manuel Dudda']
  spec.email = ['dudda@redpeppix.de']
  spec.summary = 'Tools for the AbRUPt project.'
  spec.description = 'Tools for the AbRUPt project.'
  spec.homepage = 'https://github.com/manuel84/abrupt'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'rest-client', '~> 1.7'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'addressable', '~> 2.3'
  spec.add_runtime_dependency 'commander', '~> 4.2'
  spec.add_runtime_dependency 'gyoku', '~> 1.2'
  spec.add_runtime_dependency 'rdf', '~> 1.1'
  spec.add_runtime_dependency 'linkeddata', '~> 1.1'
  spec.add_runtime_dependency 'rdf-rdfxml', '~> 1.1'
  spec.add_runtime_dependency 'rdf-raptor', '~> 1.2'
  spec.add_runtime_dependency 'json-schema', '~> 2.4'
  spec.add_runtime_dependency 'activesupport', '~> 4.1'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rubocop', '~> 0.26'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'webmock', '~> 1.20'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'factory_girl', '~> 4.5'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
end
