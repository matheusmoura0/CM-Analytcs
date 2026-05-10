class AdMetric < ApplicationRecord
  belongs_to :cached_article, foreign_key: :article_id, primary_key: :id, optional: true
  
  validates :date, presence: true
  
  scope :for_date, ->(date) { where(date: date) }
  scope :for_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  
  def self.calculate_rpm(revenue, impressions)
    return 0 if impressions.zero?
    (revenue / impressions.to_f * 1000).round(2)
  end
end
