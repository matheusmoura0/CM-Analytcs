# Puma configuration file for production - Render compatible

# Set threads
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# IMPORTANT: Force single worker mode for Render free tier
workers 0

# No timeout for worker
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Port - Render uses PORT env var
port ENV.fetch("PORT") { 3000 }

# Environment
environment ENV.fetch("RAILS_ENV") { "production" }

# PID file - disable to avoid conflicts
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Plugin
plugin :tmp_restart

# Don't preload app in production to avoid memory issues
# preload_app!

# Allow puma to be restarted by `rails restart` command
on_restart do
  puts "Refreshing Gemfile"
  load Gem.bin_path('bundler', 'bundle', 'Gem.bin_path')
end

# Before forking, set up database connection
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

# After forking, re-establish database connection
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
