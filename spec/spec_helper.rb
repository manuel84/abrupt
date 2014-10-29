require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
Bundler.setup

require 'abrupt' # and any other gems you need
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  # some (optional) config here
  config.formatter = 'documentation'
end
