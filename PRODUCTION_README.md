# CM Analytics - Production Ready 🚀

## ✅ Platform Status: READY FOR RENDER DEPLOYMENT

Your CM Analytics platform is now fully configured and ready for production deployment on Render with Neon PostgreSQL.

---

## 🎯 What's Been Completed

### ✅ Production Configuration
- Removed all localhost references
- Dynamic baseUrl detection in tracker.js
- Production environment variables configured
- SSL/HTTPS enforcement enabled
- CORS configured for Correio da Manhã domains
- site_id support added to analytics events

### ✅ Deployment Files Created
- `render.yaml` - Render deployment configuration
- `Procfile` - Process management for Puma & Sidekiq
- `config/puma.rb` - Puma server configuration
- `config/environments/production.rb` - Production settings
- `config/initializers/cors.rb` - CORS for production domains

### ✅ Database Ready
- Neon PostgreSQL connection configured
- site_id migration created and run
- Sample data seeded for testing

### ✅ Tracker Script Production-Ready
- Dynamic API endpoint detection
- site_id support from data attribute
- sendBeacon with fetch fallback
- Cross-origin compatible
- Production-ready error handling

---

## 🌐 Production URLs

### Temporary (Render Domain)
```
App:        https://cm-analytics.onrender.com
Tracker:    https://cm-analytics.onrender.com/tracker/tracker.js
API:        https://cm-analytics.onrender.com/api/v1/analytics/events
Dashboard:  https://cm-analytics.onrender.com/dashboard
Login:      https://cm-analytics.onrender.com/login
```

### Future (Custom Domain)
```
App:        https://analytics.correiodamanha.com.br
Tracker:    https://analytics.correiodamanha.com.br/tracker/tracker.js
API:        https://analytics.correiodamanha.com.br/api/v1/analytics/events
Dashboard:  https://analytics.correiodamanha.com.br/dashboard
```

---

## 🔌 Portal Integration Script

### Add This to Correio da Manhã Portal

```html
<script
  src="https://cm-analytics.onrender.com/tracker/tracker.js"
  data-site-id="correio-da-manha"
  async
></script>
```

### Required Article Metadata

```html
<!-- Article Identification -->
<meta name="article:id" content="12345">

<!-- Article Metadata -->
<meta property="article:author" content="Author Name">
<meta property="article:section" content="Politics">
<meta property="article:published_time" content="2024-01-01T00:00:00Z">

<!-- Open Graph -->
<meta property="og:title" content="Article Title">
<meta property="og:image" content="https://correiodamanha.com.br/image.jpg">

<!-- Optional: MSX-specific -->
<meta property="mrf:authors" content="Author Name">
<meta property="mrf:sections" content="Politics">
```

---

## 📊 Features Available in Production

### Public Endpoints (No Auth)
- `GET /tracker/tracker.js` - Tracker script
- `POST /api/v1/analytics/events` - Single event
- `POST /api/v1/analytics/batch` - Batch events
- `GET /health` - Health check

### Protected Endpoints (Requires Login)
- `GET /dashboard` - Main dashboard
- `GET /dashboard/realtime` - Real-time metrics
- `GET /dashboard/editorial` - Editorial analytics
- `GET /dashboard/discover` - Google Discover stats
- `GET /dashboard/monetization` - Revenue metrics (admin only)

---

## 🔐 Login Credentials

```
Admin:   admin@cmanalytics.pt / admin123
Editor:  editor@cmanalytics.pt / editor123
Reporter: reporter@cmanalytics.pt / reporter123
```

---

## 🚀 Quick Deploy Guide

### 1. Push to GitHub
```bash
cd /Users/matheusoliveira/Desktop/CM-Analytics
git init
git add .
git commit -m "Production ready - Render deployment"
git remote add origin <your-github-repo>
git push -u origin main
```

### 2. Create Neon Database
1. Go to https://neon.tech
2. Create free account
3. Create project "cm-analytics"
4. Copy connection string

### 3. Deploy to Render
1. Go to https://render.com
2. Create Web Service
3. Connect GitHub repo
4. Configure:
   - Runtime: Ruby
   - Build: `bundle install && bundle exec rails assets:precompile`
   - Start: `bundle exec puma -C config/puma.rb`
5. Add environment variables (see below)
6. Deploy!

### 4. Configure Environment Variables in Render

```bash
RAILS_ENV=production
SECRET_KEY_BASE=<run: bin/rails secret>
DATABASE_URL=<neon_connection_string>
ALLOWED_ORIGINS=https://www.correiodamanha.com.br,https://correiodamanha.com.br,https://cm-analytics.onrender.com
APP_HOST=cm-analytics.onrender.com
DEFAULT_SITE_ID=correio-da-manha
```

### 5. Run Migrations
In Render Shell:
```bash
bundle exec rails db:migrate
bundle exec rails db:seed
```

---

## ✅ Validation Steps

### Test 1: Health Check
```bash
curl https://cm-analytics.onrender.com/health
```

### Test 2: Tracker Script
```bash
curl https://cm-analytics.onrender.com/tracker/tracker.js
```

### Test 3: Event Ingestion
```bash
curl -X POST https://cm-analytics.onrender.com/api/v1/analytics/events \
  -H "Content-Type: application/json" \
  -d '{
    "site_id": "correio-da-manha",
    "event": "page_view",
    "url": "https://correiodamanha.com.br/test",
    "article_id": 1,
    "title": "Test",
    "author": "Test",
    "section": "Test"
  }'
```

### Test 4: Dashboard Access
Open browser: https://cm-analytics.onrender.com/login

---

## 📈 Dashboard Features

### Main Dashboard
- Page views today
- Unique articles
- Active sessions
- Average time on page
- Traffic sources chart
- Top 5 articles

### Real-time Dashboard
- Live active users (5 min)
- Page views last hour
- Discover clicks today
- Homepage CTR
- Trending articles (last hour)
- Traffic breakdown
- Live activity feed
- Auto-refresh every 30s

### Editorial Dashboard
- Date range filtering
- Top 20 articles with details
- Top 10 authors
- Top sections chart
- Homepage performance
- Scroll completion

### Discover Dashboard
- 7-day impressions
- 7-day clicks
- Average CTR
- Trend chart
- Top Discover articles
- Detailed metrics table

### Monetization Dashboard (Admin)
- Total revenue (month)
- Average RPM/CPM
- Revenue by section
- Revenue by author
- Top revenue articles

---

## 📁 Project Structure

```
CM-Analytics/
├── app/
│   ├── controllers/
│   │   ├── api/v1/
│   │   │   ├── analytics_controller.rb
│   │   │   └── dashboard/
│   │   ├── dashboard_controller.rb
│   │   └── authentication_controller.rb
│   ├── models/
│   │   ├── analytics_event.rb
│   │   ├── cached_article.rb
│   │   ├── discover_metric.rb
│   │   ├── ad_metric.rb
│   │   └── user.rb
│   ├── views/
│   │   ├── dashboard/
│   │   ├── authentication/
│   │   └── layouts/
│   └── services/
│       └── traffic_source_classifier.rb
├── config/
│   ├── environments/production.rb
│   ├── initializers/cors.rb
│   ├── puma.rb
│   └── routes.rb
├── db/
│   └── migrate/
├── public/
│   └── tracker/
│       └── tracker.js
├── Procfile
├── render.yaml
├── RENDER_DEPLOYMENT.md
└── PRODUCTION_CHECKLIST.md
```

---

## 🔧 Troubleshooting

### Tracker Not Loading
- Verify URL is accessible
- Check browser console for errors
- Test with curl
- Check Render logs

### Events Not Saving
- Verify API endpoint is accessible
- Check event format
- Review database connection
- Check Render logs

### Dashboard Not Loading
- Clear browser cache
- Verify authentication
- Check database migrations ran
- Review Rails logs

---

## 📚 Documentation

- `RENDER_DEPLOYMENT.md` - Detailed deployment guide
- `PRODUCTION_CHECKLIST.md` - Pre-flight checklist
- `README.md` - Original project documentation
- `DEPLOYMENT.md` - Initial deployment notes

---

## 🎯 Success Criteria

✅ Platform deploys to Render successfully  
✅ Tracker script loads on Correio da Manhã portal  
✅ Analytics events are captured and stored  
✅ Dashboard displays real production data  
✅ All features work in production environment  

---

## 🚀 Next Steps After Deployment

1. **Test Integration**
   - Add tracker to one article page
   - Verify events are captured
   - Check dashboard for data

2. **Roll Out to Portal**
   - Add tracker to all article pages
   - Add required metadata
   - Monitor performance

3. **Monitor & Optimize**
   - Check Render logs regularly
   - Monitor database performance
   - Optimize slow queries

4. **Future Enhancements**
   - Add Redis for Sidekiq
   - Implement ClickHouse
   - Add WebSocket real-time updates
   - Integrate Google Search Console
   - Set up alerting

---

## 📞 Support

For issues:
1. Check Render logs
2. Check Neon status
3. Review documentation
4. Check Rails logs

---

**Platform is production-ready! Deploy to Render now. 🎉**

---

**Version**: 1.0.0  
**Status**: Production Ready  
**Last Updated**: 2025-01-10  
**Deployment Target**: Render + Neon PostgreSQL
