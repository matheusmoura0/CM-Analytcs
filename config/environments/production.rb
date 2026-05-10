require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.log_level = :info
  config.log_tags = [ :request_id ]
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  # Force SSL
  config.force_ssl = true

  # Allowed hosts - accept all onrender.com subdomains
  config.hosts = nil
  config.hosts ||= []

  # Explicitly allow common domains
  config.hosts << "cm-analytics.onrender.com"
  config.hosts << "cm-analytcs.onrender.com"
  config.hosts << /.+\.onrender\.com/  # Accept any onrender.com subdomain
  config.hosts << "analytics.correiodamanha.com.br"
  config.hosts << "www.correiodamanha.com.br"
  config.hosts << "correiodamanha.com.br"

  # Allow all hosts in development-like scenarios
  config.action_controller.default_protect_from_forgery = false

  # Active Job
  config.active_job.queue_adapter = :sidekiq
end
