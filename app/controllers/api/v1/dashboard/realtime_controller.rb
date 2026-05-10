module Api
  module V1
    module Dashboard
      class RealtimeController < ApplicationController
        before_action :authenticate_user!
        
        def index
          metrics = {
            active_users: active_users_count,
            trending_articles: trending_articles(10),
            traffic_sources: traffic_breakdown,
            page_views_last_hour: page_views_since(1.hour.ago),
            page_views_last_5min: page_views_since(5.minutes.ago)
          }
          
          render json: metrics
        end
        
        private
        
        def active_users_count
          AnalyticsEvent.where('created_at > ?', 5.minutes.ago)
                        .group(:session_id)
                        .count
                        .keys
                        .length
        end
        
        def trending_articles(limit)
          AnalyticsEvent.where('created_at > ?', 1.hour.ago)
                        .page_views
                        .group(:article_id, :title)
                        .order('COUNT(*) DESC')
                        .limit(limit)
                        .count
                        .map { |(id, title), count| { article_id: id, title: title, views: count } }
        end
        
        def traffic_breakdown
          AnalyticsEvent.where('created_at > ?', 1.hour.ago)
                        .page_views
                        .group(:traffic_source, :traffic_medium)
                        .order('COUNT(*) DESC')
                        .count
                        .map { |(source, medium), count| { source: source, medium: medium, count: count } }
        end
        
        def page_views_since(time)
          AnalyticsEvent.where('created_at > ?', time)
                        .page_views
                        .count
        end
      end
    end
  end
end
