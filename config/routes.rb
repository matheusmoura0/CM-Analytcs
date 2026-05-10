Rails.application.routes.draw do
  # Analytics API endpoints
  namespace :api do
    namespace :v1 do
      # Event tracking
      post '/analytics/events', to: 'analytics#create'
      post '/analytics/batch', to: 'analytics#batch'

      # Dashboard endpoints (authenticated)
      namespace :dashboard do
        get '/realtime', to: 'realtime#index'
        get '/editorial', to: 'editorial#index'
        get '/discover', to: 'discover#index'
        get '/monetization', to: 'monetization#index'

        # Top performing content
        get '/top/articles', to: 'metrics#top_articles'
        get '/top/authors', to: 'metrics#top_authors'
        get '/top/sections', to: 'metrics#top_sections'

        # Traffic analytics
        get '/traffic/sources', to: 'metrics#traffic_sources'
        get '/traffic/by-hour', to: 'metrics#traffic_by_hour'
      end
    end
  end

  # Authentication
  get '/login', to: 'authentication#new', as: :login
  post '/auth/login', to: 'authentication#create', as: :login_post
  post '/logout', to: 'authentication#destroy', as: :logout

  # Dashboard web interface
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/dashboard/realtime', to: 'dashboard#realtime', as: :realtime_dashboard
  get '/dashboard/editorial', to: 'dashboard#editorial', as: :editorial_dashboard
  get '/dashboard/discover', to: 'dashboard#discover', as: :discover_dashboard
  get '/dashboard/monetization', to: 'dashboard#monetization', as: :monetization_dashboard

  # Root redirect - go to login instead of dashboard
  root to: redirect('/login')

  # Health check
  get '/health', to: 'health#index'
end
