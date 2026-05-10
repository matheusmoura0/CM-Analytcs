module Api
  module V1
    module Dashboard
      class EditorialController < ApplicationController
        before_action :authenticate_user!
        
        def index
          start_date = params[:start_date]&.to_date || 7.days.ago.to_date
          end_date = params[:end_date]&.to_date || Date.today
          
          metrics = {
            period: { start: start_date, end: end_date },
            total_page_views: total_page_views(start_date, end_date),
            unique_articles: unique_articles(start_date, end_date),
            top_articles: top_articles(start_date, end_date, 20),
            top_authors: top_authors(start_date, end_date, 10),
            top_sections: top_sections(start_date, end_date, 10),
            homepage_ctr: homepage_ctr(start_date, end_date),
            avg_engagement_time: avg_engagement_time(start_date, end_date),
            scroll_completion: scroll_completion(start_date, end_date)
          }
          
          render json: metrics
        end
        
        private
        
        def total_page_views(start_date, end_date)
          AnalyticsEvent.by_date_range(start_date, end_date)
                        .page_views
                        .count
        end
        
        def unique_articles(start_date, end_date)
          AnalyticsEvent.by_date_range(start_date, end_date)
                        .page_views
                        .distinct
                        .count(:article_id)
        end
        
        def top_articles(start_date, end_date, limit)
          AnalyticsEvent.by_date_range(start_date, end_date)
                        .page_views
                        .group(:article_id, :title, :author, :section)
                        .order('COUNT(*) DESC')
                        .limit(limit)
                        .count
                        .map { |(id, title, author, section), views| 
                          { article_id: id, title: title, author: author, section: section, views: views }
                        }
        end
        
        def top_authors(start_date, end_date, limit)
          AnalyticsEvent.by_date_range(start_date, end_date)
                        .page_views
                        .group(:author)
                        .order('COUNT(*) DESC')
                        .limit(limit)
                        .count
        end
        
        def top_sections(start_date, end_date, limit)
          AnalyticsEvent.by_date_range(start_date, end_date)
                        .page_views
                        .group(:section)
                        .order('COUNT(*) DESC')
                        .limit(limit)
                        .count
        end
        
        def homepage_ctr(start_date, end_date)
          clicks = AnalyticsEvent.by_date_range(start_date, end_date)
                                  .article_clicks
                                  .where(position: ['home_hero', 'home_featured', 'home_list'])
                                  .count
          
          views = AnalyticsEvent.by_date_range(start_date, end_date)
                                .page_views
                                .where(url: ['/', '/home'])
                                .count
          
          return 0 if views.zero?
          (clicks.to_f / views * 100).round(2)
        end
        
        def avg_engagement_time(start_date, end_date)
          times = AnalyticsEvent.by_date_range(start_date, end_date)
                                  .where.not(time_on_page: nil)
                                  .pluck(:time_on_page)
          
          return 0 if times.empty?
          (times.sum.to_f / times.length).round(0)
        end
        
        def scroll_completion(start_date, end_date)
          AnalyticsEvent.by_date_range(start_date, end_date)
                        .scroll_events
                        .group(:scroll_depth)
                        .count
        end
      end
    end
  end
end
