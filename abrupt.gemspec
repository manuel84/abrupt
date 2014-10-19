# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abrupt/version'

Gem::Specification.new do |spec|
  spec.name          = 'abrupt'
  spec.version       = Abrupt::VERSION
  spec.authors       = ['Manuel Dudda']
  spec.email         = ['dudda@redpeppix.de']
  spec.summary       = 'Tools for the AbRUPt project.'
  spec.description   = 'Tools for the AbRUPt project.'
  spec.homepage      = 'https://github.com/manuel84/abrupt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'rest-client', '~> 1.7'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rubocop', '~> 0.26'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
