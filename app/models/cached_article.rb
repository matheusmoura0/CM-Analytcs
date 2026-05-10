class CachedArticle < ApplicationRecord
  self.primary_key = 'id'
  
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :id, presence: true
  
  scope :recent, -> { order(published_at: :desc) }
  scope :by_section, ->(section) { where(section: section) }
  scope :by_author, ->(author) { where(author: author) }
  
  def self.cache_from_metadata(article_data)
    find_or_create_by(id: article_data[:id]) do |article|
      article.title = article_data[:title]
      article.slug = article_data[:slug]
      article.author = article_data[:author]
      article.section = article_data[:section]
      article.image_url = article_data[:image_url]
      article.published_at = article_data[:published_at]
      article.metadata = article_data[:metadata] || {}
    end
  end
end
