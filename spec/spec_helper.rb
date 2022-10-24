# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

require 'bundler/setup'
require 'redis'
require 'rollout'
require 'connection_pool'


REDIS = ConnectionPool.new(size: ENV.fetch('RAILS_MAX_THREADS', 5)) do
  Redis.new(url: ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379'), ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
end

# Redis.current = Redis.new(
#   host: ENV.fetch('REDIS_HOST', '127.0.0.1'),
#   port: ENV.fetch('REDIS_PORT', '6379'),
#   db: ENV.fetch('REDIS_DB', '7'),
# )

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  # config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before { REDIS.then { |conn| conn.flushdb } }
end
