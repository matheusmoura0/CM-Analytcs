require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.assets.compress = true
  config.log_level = :info
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.log_formatter = ::Logger::Formatter.new

  # Force SSL
  config.force_ssl = true
  
  # Allowed hosts
  config.hosts << "cm-analytics.onrender.com"
  config.hosts << "analytics.correiodamanha.com.br"
  config.hosts << "www.correiodamanha.com.br"
  config.hosts << "correiodamanha.com.br"

  # Active Job
  config.active_job.queue_adapter = :sidekiq

  # CORS allowed origins
  config.allowed_cors_origins = [
    "https://www.correiodamanha.com.br",
    "https://correiodamanha.com.br",
    "https://cm-analytics.onrender.com",
    "http://localhost:3000"
  ]
end
