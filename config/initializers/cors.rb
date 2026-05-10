# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Allow requests from Correio da Manhã domains and production domain

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # In development, allow all origins
    # In production, use ALLOWED_ORIGINS env var or default to CM domains
    if Rails.env.development?
      origins '*'
    else
      origins ENV.fetch('ALLOWED_ORIGINS', 'https://www.correiodamanha.com.br,https://correiodamanha.com.br,https://cm-analytics.onrender.com,https://cm-analytcs.onrender.com').split(',')
    end

    # Analytics endpoints - always allow from anywhere
    resource "/api/v1/analytics/*",
      headers: :any,
      methods: [:post, :options, :get],
      credentials: false,
      max_age: 3600

    # Dashboard APIs (requires auth)
    resource "/api/v1/dashboard/*",
      headers: :any,
      methods: [:get, :options],
      credentials: true

    # Tracker endpoint
    resource "/tracker/*",
      headers: :any,
      methods: [:get, :options],
      credentials: false
  end
end
