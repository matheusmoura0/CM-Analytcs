module Api
  module V1
    module Dashboard
      class MonetizationController < ApplicationController
        before_action :authenticate_user!
        
        def index
          start_date = params[:start_date]&.to_date || Date.today.beginning_of_month
          end_date = params[:end_date]&.to_date || Date.today
          
          metrics = {
            period: { start: start_date, end: end_date },
            total_revenue: total_revenue(start_date, end_date),
            avg_rpm: avg_rpm(start_date, end_date),
            avg_cpm: avg_cpm(start_date, end_date),
            revenue_by_section: revenue_by_section(start_date, end_date),
            revenue_by_author: revenue_by_author(start_date, end_date),
            top_revenue_articles: top_revenue_articles(start_date, end_date, 10),
            device_breakdown: device_revenue_breakdown(start_date, end_date)
          }
          
          render json: metrics
        end
        
        private
        
        def total_revenue(start_date, end_date)
          AdMetric.for_date_range(start_date, end_date).sum(:revenue)
        end
        
        def avg_rpm(start_date, end_date)
          AdMetric.for_date_range(start_date, end_date).average(:rpm)&.round(2) || 0
        end
        
        def avg_cpm(start_date, end_date)
          AdMetric.for_date_range(start_date, end_date).average(:cpm)&.round(2) || 0
        end
        
        def revenue_by_section(start_date, end_date)
          AdMetric.for_date_range(start_date, end_date)
                  .joins(:cached_article)
                  .group('cached_articles.section')
                  .sum(:revenue)
                  .map { |section, revenue| { section: section, revenue: revenue } }
                  .sort_by { |s| -s[:revenue] }
        end
        
        def revenue_by_author(start_date, end_date)
          AdMetric.for_date_range(start_date, end_date)
                  .joins(:cached_article)
                  .group('cached_articles.author')
                  .sum(:revenue)
                  .map { |author, revenue| { author: author, revenue: revenue } }
                  .sort_by { |a| -a[:revenue] }
        end
        
        def top_revenue_articles(start_date, end_date, limit)
          AdMetric.for_date_range(start_date, end_date)
                  .joins(:cached_article)
                  .group('ad_metrics.article_id', 'cached_articles.title')
                  .order('SUM(ad_metrics.revenue) DESC')
                  .limit(limit)
                  .sum(:revenue)
                  .map { |(id, title), revenue| { article_id: id, title: title, revenue: revenue } }
        end
        
        def device_revenue_breakdown(start_date, end_date)
          # This would require device-specific metrics
          # For now, return a placeholder
          {
            mobile: { revenue: 0, percentage: 0 },
            desktop: { revenue: 0, percentage: 0 },
            tablet: { revenue: 0, percentage: 0 }
          }
        end
      end
    end
  end
end
