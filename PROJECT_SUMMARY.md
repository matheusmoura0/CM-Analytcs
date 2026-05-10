# CM Analytics - Project Summary

## Overview

CM Analytics is an editorial analytics platform built for Jornal Correio da Manhã. It provides real-time and historical analytics for content performance, traffic sources, Google Discover metrics, and monetization data.

## Architecture

### High-Level Architecture
```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│  MSX Portal │ ───> │  tracker.js  │ ───> │  Rails API  │
└─────────────┘      └──────────────┘      └──────┬──────┘
                                                   │
                                                   ▼
                                          ┌─────────────────┐
                                          │   PostgreSQL    │
                                          └─────────────────┘
                                                   │
                                                   ▼
                                          ┌─────────────────┐
                                          │  Dashboard UI   │
                                          └─────────────────┘
```

### Components

1. **Tracker Script** (`/public/tracker/tracker.js`)
   - Client-side JavaScript tracking
   - Automatic page view, click, scroll, and time tracking
   - Batch event sending for performance
   - Metadata extraction from article pages

2. **Rails API Backend**
   - Event ingestion endpoints
   - Dashboard data APIs
   - Authentication and authorization
   - Background job processing

3. **Database Models**
   - `AnalyticsEvent` - All tracking events
   - `CachedArticle` - Article metadata cache
   - `DiscoverMetric` - Google Discover performance
   - `AdMetric` - Monetization data
   - `User` - Authentication and roles

4. **Dashboard Controllers**
   - `RealtimeController` - Live metrics
   - `EditorialController` - Content performance
   - `DiscoverController` - Google Discover analytics
   - `MonetizationController` - Revenue tracking

5. **Services**
   - `TrafficSourceClassifier` - Source attribution
   - `CacheArticleJob` - Article metadata caching

## Features Implemented

### ✅ Phase 1 - Tracking Foundation
- [x] tracker.js script with event tracking
- [x] Event ingestion API (single and batch)
- [x] PostgreSQL schema with proper indexes
- [x] Page view tracking
- [x] Click tracking with position
- [x] Traffic source classification

### ✅ Phase 2 - Editorial Dashboard
- [x] Top articles analytics
- [x] Author performance tracking
- [x] Section/category analytics
- [x] Homepage CTR measurement
- [x] Real-time metrics
- [x] Engagement time tracking
- [x] Scroll depth tracking

### ✅ Phase 3 - Discover & Revenue
- [x] Discover metrics data model
- [x] Discover dashboard APIs
- [x] Top Discover articles
- [x] CTR trend analysis
- [x] Revenue tracking model
- [x] Monetization dashboard
- [x] RPM/CPM calculation

### ✅ Additional Features
- [x] User authentication (session-based)
- [x] Role-based access control (admin, editor, reporter)
- [x] Background job processing setup
- [x] CORS configuration
- [x] Health check endpoint
- [x] Seed data for development
- [x] Docker Compose setup

## API Endpoints

### Event Tracking
```
POST /api/v1/analytics/events
POST /api/v1/analytics/batch
```

### Dashboard APIs
```
GET /api/v1/dashboard/realtime
GET /api/v1/dashboard/editorial
GET /api/v1/dashboard/discover
GET /api/v1/dashboard/monetization
```

### Authentication
```
POST /auth/login
POST /auth/logout
```

## Database Schema

### analytics_events
Stores all tracking events with full metadata for analytics.

### cached_articles
Caches article metadata from MSX CMS for performance.

### discover_metrics
Google Discover performance data (impressions, clicks, CTR).

### ad_metrics
Monetization data including RPM, CPM, revenue.

### users
Authentication and role management.

## Traffic Sources Supported

- **Search**: Google, Bing, DuckDuckGo
- **Social**: Facebook, Instagram, X/Twitter, LinkedIn, WhatsApp
- **Discover**: Google Discover
- **News**: Google News
- **Internal**: Same-domain referrals
- **Direct/Dark Social**: Unknown or unattributed sources

## User Roles

### Admin
- Full access to all dashboards
- User management
- System configuration

### Editor
- Section-level access
- Editorial and real-time dashboards
- Team performance metrics

### Reporter
- Own articles only
- Basic performance metrics
- Individual insights

## Installation

### Quick Start
```bash
cd /Users/matheusoliveira/Desktop/CM-Analytics
./setup.sh
```

### Manual Setup
```bash
bundle install
bin/rails db:create db:migrate db:seed
redis-server
bundle exec sidekiq
bin/rails server
```

## Development

### Default Users
- Admin: admin@cmanalytics.pt / admin123
- Editor: editor@cmanalytics.pt / editor123
- Reporter: reporter@cmanalytics.pt / reporter123

### Testing
```bash
bin/rails test
```

### Code Quality
```bash
bundle exec rubocop
bundle exec brakeman
```

## Deployment

### Production Checklist
- [ ] Set strong SECRET_KEY_BASE
- [ ] Configure production database
- [ ] Set up Redis for Sidekiq
- [ ] Configure CORS for production domains
- [ ] Set up monitoring and error tracking
- [ ] Configure backup strategy
- [ ] Set up SSL certificates
- [ ] Configure CDN for tracker.js
- [ ] Set up Google Search Console integration

### Docker Deployment
```bash
docker-compose up -d
```

## Next Steps

### Immediate
1. Test the API endpoints with sample data
2. Set up real Redis and Sidekiq for background jobs
3. Test tracker.js integration on a staging site
4. Configure Google Search Console API integration

### Future Enhancements
1. WebSocket support for real-time updates
2. ActionCable integration for live dashboard
3. Export functionality for reports
4. Email alerts for anomaly detection
5. A/B testing headline testing
6. Editorial recommendation engine
7. MSX CMS webhook integration
8. Historical data aggregation

## File Structure

```
CM-Analytics/
├── app/
│   ├── controllers/
│   │   ├── analytics_controller.rb
│   │   ├── dashboard_controller.rb
│   │   ├── authentication_controller.rb
│   │   ├── health_controller.rb
│   │   └── api/v1/dashboard/
│   │       ├── realtime_controller.rb
│   │       ├── editorial_controller.rb
│   │       ├── discover_controller.rb
│   │       └── monetization_controller.rb
│   ├── models/
│   │   ├── analytics_event.rb
│   │   ├── cached_article.rb
│   │   ├── discover_metric.rb
│   │   ├── ad_metric.rb
│   │   └── user.rb
│   ├── jobs/
│   │   └── cache_article_job.rb
│   └── services/
│       └── traffic_source_classifier.rb
├── public/
│   └── tracker/
│       └── tracker.js
├── config/
│   ├── routes.rb
│   └── initializers/
│       ├── cors.rb
│       └── sidekiq.rb
├── db/
│   ├── migrate/
│   └── seeds.rb
├── docker-compose.yml
├── setup.sh
└── README.md
```

## Support

For questions or issues, contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: 2025-01-10  
**Status**: Development Ready
