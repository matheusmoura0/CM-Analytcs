class TrafficSourceClassifier
  SOURCE_RULES = {
    'google.com' => { medium: 'search', source: 'Google' },
    'google.*' => { medium: 'search', source: 'Google' },
    'bing.com' => { medium: 'search', source: 'Bing' },
    'duckduckgo.com' => { medium: 'search', source: 'DuckDuckGo' },
    'news.google.com' => { medium: 'news', source: 'Google News' },
    'discover.google.com' => { medium: 'discover', source: 'Google Discover' },
    'facebook.com' => { medium: 'social', source: 'Facebook' },
    'fb.watch' => { medium: 'social', source: 'Facebook' },
    'instagram.com' => { medium: 'social', source: 'Instagram' },
    'twitter.com' => { medium: 'social', source: 'X (Twitter)' },
    't.co' => { medium: 'social', source: 'X (Twitter)' },
    'x.com' => { medium: 'social', source: 'X (Twitter)' },
    'linkedin.com' => { medium: 'social', source: 'LinkedIn' },
    'whatsapp.com' => { medium: 'social', source: 'WhatsApp' },
    'telegram.me' => { medium: 'social', source: 'Telegram' },
    'reddit.com' => { medium: 'social', source: 'Reddit' },
    'youtube.com' => { medium: 'social', source: 'YouTube' },
    'pinterest.com' => { medium: 'social', source: 'Pinterest' },
    'tiktok.com' => { medium: 'social', source: 'TikTok' }
  }.freeze
  
  class << self
    def classify(referrer, current_domain)
      return { medium: 'direct', source: 'Direct' } if referrer.blank? || referrer == 'direct'
      
      uri = parse_uri(referrer)
      return { medium: 'direct', source: 'Direct' } unless uri
      
      domain = extract_domain(uri)
      
      # Check if internal traffic
      if current_domain.present? && domain.include?(current_domain)
        return { medium: 'internal', source: 'Internal' }
      end
      
      # Match against source rules
      SOURCE_RULES.each do |pattern, info|
        if File.fnmatch?(pattern, domain) || domain == pattern
          return info
        end
      end
      
      # Dark social for patterns we can't identify
      if dark_social?(referrer)
        { medium: 'dark_social', source: 'Dark Social' }
      else
        { medium: 'other', source: domain }
      end
    end
    
    private
    
    def parse_uri(referrer)
      URI.parse(referrer)
    rescue URI::InvalidURIError
      nil
    end
    
    def extract_domain(uri)
      uri.host.downcase
    end
    
    def dark_social?(referrer)
      # Detect patterns that suggest dark social
      referrer.include?('utm_source') ||
      referrer.include?('/l/') ||  # LinkedIn mobile
      referrer.include?('mailto:') ||
      (referrer.start_with?('http://') && referrer.include?('/amp/'))
    end
  end
end
