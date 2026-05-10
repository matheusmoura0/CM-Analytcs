class DiscoverMetric < ApplicationRecord
  belongs_to :cached_article, foreign_key: :article_id, primary_key: :id, optional: true
  
  validates :date, presence: true
  validates :article_id, presence: true
  
  scope :for_date, ->(date) { where(date: date) }
  scope :for_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :top_performing, -> { order(clicks: :desc) }
  
  def self.update_metrics(article_id, impressions:, clicks:, date:)
    metric = find_or_initialize_by(article_id: article_id, date: date)
    metric.impressions = impressions
    metric.clicks = clicks
    metric.ctr = clicks.to_f / impressions * 100 if impressions.positive?
    metric.save
    metric
  end
end
