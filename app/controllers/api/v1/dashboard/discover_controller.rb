module Api
  module V1
    module Dashboard
      class DiscoverController < ApplicationController
        before_action :authenticate_user!
        
        def index
          start_date = params[:start_date]&.to_date || 7.days.ago.to_date
          end_date = params[:end_date]&.to_date || Date.today
          
          metrics = {
            period: { start: start_date, end: end_date },
            total_impressions: total_impressions(start_date, end_date),
            total_clicks: total_clicks(start_date, end_date),
            avg_ctr: avg_ctr(start_date, end_date),
            top_articles: top_discover_articles(start_date, end_date, 20),
            daily_trend: daily_discover_trend(start_date, end_date),
            discover_growth: discover_growth(start_date, end_date)
          }
          
          render json: metrics
        end
        
        private
        
        def total_impressions(start_date, end_date)
          DiscoverMetric.for_date_range(start_date, end_date).sum(:impressions)
        end
        
        def total_clicks(start_date, end_date)
          DiscoverMetric.for_date_range(start_date, end_date).sum(:clicks)
        end
        
        def avg_ctr(start_date, end_date)
          DiscoverMetric.for_date_range(start_date, end_date).average(:ctr)&.round(2) || 0
        end
        
        def top_discover_articles(start_date, end_date, limit)
          DiscoverMetric.for_date_range(start_date, end_date)
                        .joins(:cached_article)
                        .order(clicks: :desc)
                        .limit(limit)
                        .map do |metric|
                          {
                            article_id: metric.article_id,
                            title: metric.cached_article&.title,
                            impressions: metric.impressions,
                            clicks: metric.clicks,
                            ctr: metric.ctr
                          }
                        end
        end
        
        def daily_discover_trend(start_date, end_date)
          DiscoverMetric.for_date_range(start_date, end_date)
                        .group(:date)
                        .order(:date)
                        .pluck(:date, :impressions, :clicks)
                        .map { |date, impr, clk| { date: date, impressions: impr, clicks: clk } }
        end
        
        def discover_growth(start_date, end_date)
          current_period = DiscoverMetric.for_date_range(start_date, end_date).sum(:clicks)
          previous_start = start_date - (end_date - start_date).days - 1.day
          previous_end = start_date - 1.day
          
          previous_period = DiscoverMetric.for_date_range(previous_start, previous_end).sum(:clicks)
          
          return 0 if previous_period.zero?
          
          growth = ((current_period - previous_period).to_f / previous_period * 100).round(2)
          
          {
            current: current_period,
            previous: previous_period,
            growth_percent: growth
          }
        end
      end
    end
  end
end
