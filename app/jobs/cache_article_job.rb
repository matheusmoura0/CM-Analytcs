class CacheArticleJob < ApplicationJob
  queue_as :default
  
  def perform(article_id, metadata = {})
    # Check if article already exists in cache
    return if CachedArticle.exists?(id: article_id)
    
    # Fetch article metadata from MSX CMS
    article_data = fetch_article_from_msx(article_id)
    
    # Cache the article
    CachedArticle.create!(
      id: article_id,
      title: article_data[:title],
      slug: article_data[:slug],
      author: article_data[:author],
      section: article_data[:section],
      image_url: article_data[:image_url],
      published_at: article_data[:published_at],
      metadata: metadata
    )
  rescue StandardError => e
    Rails.logger.error("Failed to cache article #{article_id}: #{e.message}")
  end
  
  private
  
  def fetch_article_from_msx(article_id)
    # Integration with MSX CMS would go here
    # For now, return default structure
    {
      title: metadata[:title] || "Untitled",
      slug: "article-#{article_id}",
      author: metadata[:author] || "Unknown",
      section: metadata[:section] || "Geral",
      image_url: metadata[:image],
      published_at: Time.current
    }
  end
end
