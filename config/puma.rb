# Puma configuration file for production - Render compatible

# Set threads
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# IMPORTANT: Force single worker mode for Render
workers 0

# Timeout
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Port
port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "development" }

# PID file
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Plugin
plugin :tmp_restart

# Preload app for performance
preload_app!

# Max requests per worker (optional, helps with memory leaks)
max_requests_count = ENV.fetch("RAILS_MAX_REQUESTS") { 1000 }.to_i
max_requests max_requests_count
