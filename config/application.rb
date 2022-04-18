require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.token_secret_signature_key = -> { Rails.application.credentials.read }

    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += [config.root.join('app')]

    config.generators do |g|
      g.test_framework :rspec,
                        view_specs: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false,
                        controller_specs: true
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # config.cache_store = :redis_store, 'redis://localhost:6379/0/cache/', { expires_in: 90.minutes }
    
    cache_servers = %w(redis://cache-01:6379/0 redis://cache-02:6379/0)
    config.cache_store = :redis_cache_store, { 
      url: cache_servers,
      connect_timeout: 30,
      read_timeout: 0.2,
      write_timeout: 0.2,
      reconnect_attempts: 1,
      
      error_handler: -> (method:, returning:, exception:) {
        Raven.capture_exception exception, level: 'warning',
        tags: { method: method, returning: returning }
      }
    }
  end
end
