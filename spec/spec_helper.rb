require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
Bundler.setup

require 'abrupt' # and any other gems you need
require 'vcr'
require 'factory_girl'
require_relative '../spec/factories/crawled_hashes.rb'
require 'json-schema'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_hosts 'codeclimate.com'
end

RSpec.configure do |config|
  # some (optional) config here
  config.formatter = 'documentation'
  config.include FactoryGirl::Syntax::Methods
  config.filter_run_excluding dev: true
  config.filter_run_excluding beta: true
  config.filter_run_excluding broken_on_ci: true
end
