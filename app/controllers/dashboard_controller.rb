class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @page_title = "Dashboard"
  end
  
  def realtime
    @page_title = "Real-time Dashboard"
    @active_users = AnalyticsEvent.where('created_at > ?', 5.minutes.ago)
                                   .group(:session_id)
                                   .count
                                   .keys
                                   .length
    
    trending = AnalyticsEvent.where('created_at > ?', 1.hour.ago)
                            .page_views
                            .group(:article_id, :title)
                            .count
    @trending_articles = trending.sort_by { |k, v| -v }.first(10).to_h
    
    @traffic_sources = AnalyticsEvent.where('created_at > ?', 1.hour.ago)
                                     .page_views
                                     .group(:traffic_source)
                                     .count
                                     .sort_by { |k, v| -v }
                                     .to_h
                                     
    @homepage_clicks = AnalyticsEvent.article_clicks
                                      .by_date(Date.today)
                                      .group(:position)
                                      .count
  end
  
  def editorial
    @page_title = "Editorial Dashboard"
    @start_date = params[:start_date]&.to_date || 7.days.ago.to_date
    @end_date = params[:end_date]&.to_date || Date.today
    
    # Top articles in date range
    articles_data = AnalyticsEvent.by_date_range(@start_date, @end_date)
                                  .page_views
                                  .group(:article_id, :title, :author, :section)
                                  .count
                                  .sort_by { |k, v| -v }
                                  .first(20)
    
    @top_articles = articles_data.map { |(id, title, author, section), views| 
      { article_id: id, title: title, author: author, section: section, views: views }
    }
    
    # Top authors
    @top_authors = AnalyticsEvent.by_date_range(@start_date, @end_date)
                                  .page_views
                                  .group(:author)
                                  .count
                                  .sort_by { |k, v| -v }
                                  .first(10)
                                  .to_h
    
    # Top sections
    @top_sections = AnalyticsEvent.by_date_range(@start_date, @end_date)
                                   .page_views
                                   .group(:section)
                                   .count
                                   .sort_by { |k, v| -v }
                                   .first(10)
                                   .to_h
    
    # Homepage clicks
    @homepage_clicks = AnalyticsEvent.article_clicks
                                      .by_date_range(@start_date, @end_date)
                                      .group(:position)
                                      .count
  end
  
  def discover
    @page_title = "Discover Dashboard"
    
    # Discover metrics from the last 7 days
    @discover_metrics = DiscoverMetric.for_date_range(7.days.ago.to_date, Date.today)
                                      .order(clicks: :desc)
                                      .limit(20)
    
    # Top performing articles on Discover
    @top_discover = DiscoverMetric.for_date_range(7.days.ago.to_date, Date.today)
                                   .order(clicks: :desc)
                                   .limit(10)
                                   
    # Discover CTR trend
    @ctr_trend = DiscoverMetric.for_date_range(30.days.ago.to_date, Date.today)
                               .group(:date)
                               .average(:ctr)
  end
  
  def monetization
    @page_title = "Monetization Dashboard"
    start_of_month = Date.today.beginning_of_month
    
    # Revenue by section - using safe aggregation
    section_revenue = AdMetric.for_date_range(start_of_month, Date.today)
                              .joins(:cached_article)
                              .group('cached_articles.section')
                              .sum(:revenue)
    
    @revenue_by_section = section_revenue.map { |section, revenue| 
      { section: section || 'Geral', revenue: revenue } 
    }.sort_by { |s| -s[:revenue] }
    
    # Revenue by author
    author_revenue = AdMetric.for_date_range(start_of_month, Date.today)
                             .joins(:cached_article)
                             .group('cached_articles.author')
                             .sum(:revenue)
    
    @revenue_by_author = author_revenue.map { |author, revenue| 
      { author: author || 'Desconhecido', revenue: revenue } 
    }.sort_by { |a| -a[:revenue] }
    
    @avg_rpm = AdMetric.for_date_range(7.days.ago.to_date, Date.today).average(:rpm) || 0
    @avg_cpm = AdMetric.for_date_range(7.days.ago.to_date, Date.today).average(:cpm) || 0
    
    # For top revenue articles, we need to use a different approach
    @top_revenue_articles = []
    
    # Get all ad metrics for the period and aggregate in Ruby
    monthly_metrics = AdMetric.for_date_range(start_of_month, Date.today)
                             .joins(:cached_article)
                             .select('ad_metrics.article_id, cached_articles.title, ad_metrics.rpm, ad_metrics.cpm, SUM(ad_metrics.revenue) as total_revenue')
                             .group('ad_metrics.article_id, cached_articles.title, ad_metrics.rpm, ad_metrics.cpm')
                             .order('total_revenue DESC')
                             .limit(10)
    
    monthly_metrics.each do |metric|
      @top_revenue_articles << {
        article_id: metric.article_id,
        title: metric.title || "Artigo ##{metric.article_id}",
        revenue: metric.total_revenue,
        rpm: metric.rpm,
        cpm: metric.cpm
      }
    end
  end
end
