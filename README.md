# CM Analytics

Editorial analytics platform for Jornal Correio da Manhã, inspired by Marfeel, Chartbeat, and Parse.ly.

## Features

- **Real-time Analytics**: Live newsroom monitoring with active users and trending articles
- **Editorial Dashboard**: Top articles, authors, sections, and homepage CTR
- **Discover Dashboard**: Google Discover performance tracking with impressions, clicks, and CTR
- **Monetization Dashboard**: RPM, CPM, and revenue analytics by article, section, and author
- **Traffic Source Classification**: Automatic detection of search, social, discover, and direct traffic
- **User Roles**: Admin, Editor, and Reporter roles with appropriate access levels

## Tech Stack

- **Backend**: Ruby on Rails 8.1.3
- **Database**: PostgreSQL
- **Background Jobs**: Sidekiq + Redis
- **Frontend**: Rails Views + Hotwire/Turbo + Chartkick
- **Real-time**: ActionCable
- **Analytics**: Custom tracking script

## Installation

### Prerequisites

- Ruby 3.3+
- PostgreSQL 12+
- Redis 7+
- Node.js 18+ (for asset compilation)

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd CM-Analytics
```

2. Install dependencies:
```bash
bundle install
npm install
```

3. Configure database:
```bash
cp config/database.yml.example config/database.yml
# Edit config/database.yml with your database credentials
```

4. Create and migrate database:
```bash
bin/rails db:create
bin/rails db:migrate
```

5. Start Redis:
```bash
redis-server
```

6. Start Sidekiq:
```bash
bundle exec sidekiq
```

7. Start Rails server:
```bash
bin/rails server
```

8. Access the dashboard at `http://localhost:3000`

## Tracking Integration

Add the tracker script to your MSX portal:

```html
<script src="https://your-domain.com/tracker/tracker.js" 
        data-site-id="YOUR_SITE_ID"
        async></script>
```

Or configure with custom endpoint:

```html
<script>
  window.CM_ANALYTICS_ENDPOINT = 'https://your-api-domain.com/api/v1/analytics/events';
  window.CM_ANALYTICS_SITE_ID = 'your-site-id';
</script>
<script src="https://your-domain.com/tracker/tracker.js" async></script>
```

### Required Metadata

For accurate tracking, ensure your articles include:

```html
<meta property="article:author" content="Author Name">
<meta property="article:section" content="Politics">
<meta property="article:published_time" content="2024-01-01T00:00:00Z">
<meta property="og:title" content="Article Title">
<meta property="og:image" content="https://example.com/image.jpg">
```

## API Endpoints

### Event Tracking

- `POST /api/v1/analytics/events` - Single event
- `POST /api/v1/analytics/batch` - Batch events

### Dashboard APIs

- `GET /api/v1/dashboard/realtime` - Real-time metrics
- `GET /api/v1/dashboard/editorial` - Editorial analytics
- `GET /api/v1/dashboard/discover` - Discover metrics
- `GET /api/v1/dashboard/monetization` - Revenue data

### Authentication

- `POST /auth/login` - User login
- `POST /auth/logout` - User logout

## User Roles

### Admin
- Full access to all dashboards
- User management
- System configuration

### Editor
- Access to assigned sections
- Editorial and real-time dashboards
- Cannot access monetization data

### Reporter
- Access to own articles only
- Limited performance metrics
- Cannot access competitor data

## Development

### Running Tests

```bash
bin/rails test
```

### Code Quality

```bash
bundle exec rubocop
```

### Security Audit

```bash
bundle exec brakeman
bundle exec bundler-audit check
```

## Deployment

### Docker

```bash
docker build -t cm-analytics .
docker run -p 3000:3000 -e DATABASE_URL=... cm-analytics
```

### Kamal

```bash
bundle exec kamal setup
bundle exec kamal deploy
```

## Environment Variables

```bash
DATABASE_URL=postgresql://user:password@host/database
REDIS_URL=redis://localhost:6379/0
RAILS_ENV=production
SECRET_KEY_BASE=your-secret-key
CM_ANALYTICS_SITE_ID=your-site-id
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

Proprietary - Copyright © 2024 Jornal Correio da Manhã

## Support

For support, contact the development team at dev@correiodamanha.pt
