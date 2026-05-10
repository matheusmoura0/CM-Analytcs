class AnalyticsEvent < ApplicationRecord
  validates :event_type, presence: true
  validates :url, presence: true
  validates :session_id, presence: true
  
  scope :page_views, -> { where(event_type: 'page_view') }
  scope :article_clicks, -> { where(event_type: 'article_click') }
  scope :scroll_events, -> { where(event_type: 'scroll_depth') }
  scope :by_article, ->(article_id) { where(article_id: article_id) }
  scope :by_author, ->(author) { where(author: author) }
  scope :by_section, ->(section) { where(section: section) }
  scope :by_date, ->(date) { where('DATE(created_at) = ?', date) }
  scope :by_date_range, ->(start_date, end_date) { where(created_at: start_date.beginning_of_day..end_date.end_of_day) }
  scope :by_source, ->(source) { where(traffic_source: source) }
  scope :by_medium, ->(medium) { where(traffic_medium: medium) }
  scope :recent, -> { order(created_at: :desc) }
  
  def self.top_articles(limit: 10)
    page_views.group(:article_id, :title).count.sort_by { |k, v| -v }.first(limit).to_h
  end
  
  def self.top_authors(limit: 10)
    page_views.group(:author).count.sort_by { |k, v| -v }.first(limit).to_h
  end
  
  def self.top_sections(limit: 10)
    page_views.group(:section).count.sort_by { |k, v| -v }.first(limit).to_h
  end
  
  def self.traffic_sources
    page_views.group(:traffic_source).count
  end
end
