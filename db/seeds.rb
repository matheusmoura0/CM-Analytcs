# Seed file for CM Analytics development

# Create admin user
admin = User.find_or_create_by(email: 'admin@cmanalytics.pt') do |user|
  user.name = 'Admin User'
  user.password = 'admin123'
  user.role = 'admin'
end
puts "Created admin user: #{admin.email}"

# Create editor user
editor = User.find_or_create_by(email: 'editor@cmanalytics.pt') do |user|
  user.name = 'Editor User'
  user.password = 'editor123'
  user.role = 'editor'
  user.permissions = { sections: ['Politics', 'Economy', 'Sports'] }
end
puts "Created editor user: #{editor.email}"

# Create reporter user
reporter = User.find_or_create_by(email: 'reporter@cmanalytics.pt') do |user|
  user.name = 'Reporter User'
  user.password = 'reporter123'
  user.role = 'reporter'
  user.permissions = { sections: ['Culture'] }
end
puts "Created reporter user: #{reporter.email}"

# Create sample cached articles
sample_articles = [
  { id: 1, title: 'Portugal ganha jogo histórico', slug: 'portugal-ganha-jogo-historico', author: 'João Silva', section: 'Desporto', published_at: 2.days.ago },
  { id: 2, title: 'Novas medidas económicas anunciadas', slug: 'novas-medidas-economicas-anunciadas', author: 'Maria Santos', section: 'Economia', published_at: 1.day.ago },
  { id: 3, title: 'Concerto ao ar livre atrai milhares', slug: 'concerto-ar-livre-atrai-milhares', author: 'Pedro Costa', section: 'Cultura', published_at: 3.hours.ago },
  { id: 4, title: 'Política de saúde atualizada', slug: 'politica-saude-atualizada', author: 'Ana Rodrigues', section: 'Política', published_at: 5.hours.ago },
  { id: 5, title: 'Tecnologia revoluciona agricultura', slug: 'tecnologia-revoluciona-agricultura', author: 'Carlos Mendes', section: 'Tecnologia', published_at: 1.hour.ago }
]

sample_articles.each do |article_data|
  article = CachedArticle.find_or_create_by(id: article_data[:id]) do |article|
    article.title = article_data[:title]
    article.slug = article_data[:slug]
    article.author = article_data[:author]
    article.section = article_data[:section]
    article.published_at = article_data[:published_at]
  end
  puts "Created article: #{article.title}"
end

# Create sample analytics events
sources = ['Google', 'Facebook', 'Direct', 'Google Discover', 'X (Twitter)']
sections = ['Desporto', 'Economia', 'Cultura', 'Política', 'Tecnologia']
devices = ['mobile', 'desktop', 'tablet']

1000.times do |i|
  article = CachedArticle.order('RANDOM()').first
  source = sources.sample
  
  AnalyticsEvent.create!(
    event_type: 'page_view',
    article_id: article.id,
    title: article.title,
    author: article.author,
    section: article.section,
    url: "https://example.com/#{article.slug}",
    referrer: source == 'Direct' ? 'direct' : "https://#{source.downcase.gsub(' ', '.')}.com",
    session_id: SecureRandom.uuid,
    traffic_source: source,
    traffic_medium: source.include?('Google') ? 'search' : 'social',
    device_type: devices.sample,
    browser: ['Chrome', 'Safari', 'Firefox'].sample,
    os: ['iOS', 'Android', 'Windows', 'macOS'].sample,
    country: 'Portugal',
    city: ['Lisbon', 'Porto', 'Braga', 'Coimbra'].sample,
    created_at: rand(1..7).days.ago
  )
end

puts "Created 1000 sample analytics events"

# Create sample discover metrics
CachedArticle.all.each do |article|
  (Date.today - 7.days..Date.today).each do |date|
    DiscoverMetric.create!(
      article_id: article.id,
      impressions: rand(1000..50000),
      clicks: rand(50..2000),
      ctr: rand(1.0..10.0).round(2),
      date: date
    )
  end
end

puts "Created sample discover metrics"

puts "\n✅ Seed completed successfully!"
puts "\n📝 Login credentials:"
puts "   Admin: admin@cmanalytics.pt / admin123"
puts "   Editor: editor@cmanalytics.pt / editor123"
puts "   Reporter: reporter@cmanalytics.pt / reporter123"
