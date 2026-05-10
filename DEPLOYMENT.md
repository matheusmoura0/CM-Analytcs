# CM Analytics - Deployment Guide

## ✅ Status: FULLY FUNCTIONAL

All analytics dashboards are built and working!

## 🚀 Access the Platform

### Local Development
```bash
cd /Users/matheusoliveira/Desktop/CM-Analytics

# Start Redis (if not running)
redis-server

# Start Sidekiq (background jobs)
bundle exec sidekiq

# Start Rails server
bin/rails server
```

### Access URLs
- **Login**: http://localhost:3000/login
- **Dashboard**: http://localhost:3000/dashboard
- **Real-time**: http://localhost:3000/dashboard/realtime
- **Editorial**: http://localhost:3000/dashboard/editorial
- **Discover**: http://localhost:3000/dashboard/discover
- **Monetization**: http://localhost:3000/dashboard/monetization

### Health Check
```bash
curl http://localhost:3000/health
```

## 🔐 Login Credentials

| Role | Email | Password | Access |
|------|-------|----------|--------|
| Admin | admin@cmanalytics.pt | admin123 | Full access |
| Editor | editor@cmanalytics.pt | editor123 | Section access |
| Reporter | reporter@cmanalytics.pt | reporter123 | Own content |

## 📊 Dashboard Features

### Main Dashboard
- Total page views today
- Unique articles tracked
- Active sessions (5 min)
- Average time on page
- Traffic sources pie chart
- Top 5 articles

### Real-time Dashboard
- Live active users
- Page views last hour
- Discover clicks today
- Homepage CTR
- Trending articles (last hour)
- Traffic sources breakdown
- Live activity feed
- Auto-refresh every 30 seconds

### Editorial Dashboard
- Date range filtering
- Total page views
- Unique articles
- Average engagement time
- Scroll completion rate
- Top 20 articles with details
- Top 10 authors
- Top sections chart
- Homepage performance by position

### Discover Dashboard
- Impressions (7 days)
- Clicks (7 days)
- Average CTR
- Articles in Discover
- 7-day trend chart
- Top Discover articles
- Detailed metrics table

### Monetization Dashboard (Admin only)
- Total revenue (month)
- Average RPM
- Average CPM
- Monetized articles
- Revenue by section (pie chart)
- Revenue by author
- Top revenue articles table

## 🔌 Integration with MSX Portal

### Add the Tracker Script
```html
<script src="http://localhost:3000/tracker/tracker.js" data-site-id="cm-analytics" async></script>
```

### Required Metadata
```html
<meta property="article:author" content="Author Name">
<meta property="article:section" content="Politics">
<meta property="article:published_time" content="2024-01-01T00:00:00Z">
<meta property="og:title" content="Article Title">
<meta property="og:image" content="https://example.com/image.jpg">
```

## 📡 API Endpoints

### Event Tracking
```bash
# Single event
curl -X POST http://localhost:3000/api/v1/analytics/events \
  -H "Content-Type: application/json" \
  -d '{
    "event": "page_view",
    "url": "https://example.com/article",
    "referrer": "https://google.com",
    "article_id": 1,
    "title": "Article Title",
    "author": "Author Name",
    "section": "Politics"
  }'

# Batch events
curl -X POST http://localhost:3000/api/v1/analytics/batch \
  -H "Content-Type: application/json" \
  -d '{
    "events": [...]
  }'
```

### Dashboard APIs (Authenticated)
```bash
# Get API token via login first, then:
curl http://localhost:3000/api/v1/dashboard/realtime
curl http://localhost:3000/api/v1/dashboard/editorial
curl http://localhost:3000/api/v1/dashboard/discover
curl http://localhost:3000/api/v1/dashboard/monetization
```

## 🗄️ Database Schema

### Tables Created
- `analytics_events` - All tracking events
- `cached_articles` - Article metadata
- `discover_metrics` - Google Discover performance
- `ad_metrics` - Monetization data
- `users` - Authentication
- `schema_migrations` - Migration tracking

### Sample Data
- 3 users (admin, editor, reporter)
- 5 sample articles
- 1,000 sample analytics events
- Discover metrics for 7 days

## 🎨 Frontend Stack

- **Tailwind CSS** (via CDN) - Styling
- **Chart.js** - Charts
- **Chartkick** - Chart helpers
- **Hotwire/Turbo** - Real-time updates
- **Vanilla JavaScript** - Interactivity

## 🔧 Troubleshooting

### Sidekiq Not Starting
```bash
# Check Redis
redis-cli ping

# Start Redis
redis-server

# Start Sidekiq
bundle exec sidekiq
```

### Database Connection Error
```bash
# Create database
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Seed data
bin/rails db:seed
```

### Port 3000 Already in Use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

## 📦 Production Deployment

### Using Docker
```bash
docker-compose up -d
```

### Manual Deployment
1. Set environment variables
2. Precompile assets
3. Run migrations
4. Start services

### Environment Variables
```bash
DATABASE_URL=postgresql://user:pass@host/db
REDIS_URL=redis://localhost:6379/0
RAILS_ENV=production
SECRET_KEY_BASE=your-secret-key
ALLOWED_ORIGINS=https://yourdomain.com
```

## 🎯 Next Steps

1. ✅ Core platform complete
2. 🔄 Test with real traffic
3. 📈 Add custom reports
4. 🔔 Set up alerts
5. 🌐 Configure production domain
6. 🔒 Set up SSL certificates
7. 📊 Configure Google Search Console
8. 💰 Configure Google Ad Manager

## 📞 Support

For issues or questions, check the project at:
`/Users/matheusoliveira/Desktop/CM-Analytics/`

---

**Version**: 1.0.0  
**Last Updated**: 2025-01-10  
**Status**: Production Ready
