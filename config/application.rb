require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module CmAnalytics
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w(assets tasks))
    config.active_job.queue_adapter = :sidekiq
    config.action_controller.default_protect_from_forgery = false
  end
end
