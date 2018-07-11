# frozen_string_literal: true

require 'simplecov'
require 'coveralls'
require 'webmock'
require 'vcr'
require 'timecop'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end

formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
]
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
SimpleCov.start do
  add_filter '/spec/'
end

require 'bundler/setup'
require 'site_health'
require 'byebug'

Dir['spec/support/**/*.rb'].each { |f| require_relative "../#{f}" }

RSpec.configure do |config|
  # Runs tests in random order
  config.order = 'random'

  config.include SiteHealth::SpecHelper

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
