# CM Analytics - Render + Neon Deployment Guide

## 🚀 Production Deployment

This guide will help you deploy CM Analytics to Render with Neon PostgreSQL.

---

## 📋 Prerequisites

- GitHub account with the CM Analytics code pushed
- Render account (free tier available)
- Neon account (free tier available)
- Correio da Manhã domain access

---

## 🗄️ Step 1: Set Up Neon PostgreSQL

### 1.1 Create Neon Account
1. Go to [https://neon.tech](https://neon.tech)
2. Sign up for a free account
3. Create a new project called "cm-analytics"

### 1.2 Get Database URL
1. In Neon dashboard, go to your project
2. Copy the **Connection String**
3. Format: `postgresql://user:password@host/database`

---

## 🌐 Step 2: Deploy to Render

### 2.1 Connect GitHub
1. Go to [https://render.com](https://render.com)
2. Sign up/login
3. Click "New +" → "Web Service"
4. Connect your GitHub repository
5. Select the `CM-Analytics` repository

### 2.2 Configure Web Service

**Basic Settings:**
- **Name**: `cm-analytics`
- **Region**: Oregon (or closest to Brazil)
- **Branch**: `main`
- **Root Directory**: `.` (leave empty)
- **Runtime**: Ruby
- **Build Command**: `bundle install && bundle exec rails assets:precompile`
- **Start Command**: `bundle exec puma -C config/puma.rb`

**Instance Type:**
- **Type**: Free
- **RAM**: 512 MB
- **CPU**: 0.1 vCPU

### 2.3 Add Environment Variables

Add these in Render → Environment:

```bash
RAILS_ENV=production
SECRET_KEY_BASE=generate_with_bin_rails_secret
DATABASE_URL=your_neon_connection_string
ALLOWED_ORIGINS=https://www.correiodamanha.com.br,https://correiodamanha.com.br
APP_HOST=cm-analytics.onrender.com
DEFAULT_SITE_ID=correio-da-manha
```

### 2.4 Deploy

1. Click "Create Web Service"
2. Render will deploy your app
3. Wait for deployment to complete (~5-10 minutes)
4. Your app will be at: `https://cm-analytics.onrender.com`

---

## 🔐 Step 3: Generate Secret Key

Run this locally to generate a secret key:

```bash
cd /Users/matheusoliveira/Desktop/CM-Analytics
bin/rails secret
```

Copy the output and add it as `SECRET_KEY_BASE` in Render environment variables.

---

## 📊 Step 4: Run Database Migrations

### Option A: Render Console
1. Go to your web service in Render
2. Click "Shell" tab
3. Run:
```bash
bundle exec rails db:migrate
bundle exec rails db:seed
```

### Option B: Render CLI
```bash
render deploy cm-analytics --migration-command="bundle exec rails db:migrate"
```

---

## ✅ Step 5: Validate Deployment

### 5.1 Check Health Endpoint
```bash
curl https://cm-analytics.onrender.com/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "...",
  "version": "1.0.0",
  "database": true
}
```

### 5.2 Test Tracker Script
Open in browser:
```
https://cm-analytics.onrender.com/tracker/tracker.js
```

Expected: JavaScript code displays

### 5.3 Test Event Endpoint
```bash
curl -X POST https://cm-analytics.onrender.com/api/v1/analytics/events \
  -H "Content-Type: application/json" \
  -d '{
    "site_id": "correio-da-manha",
    "event": "page_view",
    "url": "https://correiodamanha.com.br/test",
    "referrer": "https://google.com",
    "article_id": 1,
    "title": "Test Article",
    "author": "Test Author",
    "section": "Test Section"
  }'
```

Expected response:
```json
{
  "status": "success",
  "event_id": 1
}
```

### 5.4 Test Dashboard
1. Open: `https://cm-analytics.onrender.com/login`
2. Login with admin credentials
3. Verify dashboard loads

---

## 🔌 Step 6: Integrate with Correio da Manhã Portal

### 6.1 Add Script to Portal
Add this to your portal's `<head>` section:

```html
<script
  src="https://cm-analytics.onrender.com/tracker/tracker.js"
  data-site-id="correio-da-manha"
  async
></script>
```

### 6.2 Add Required Metadata
Ensure all articles have:

```html
<meta property="article:author" content="Author Name">
<meta property="article:section" content="Politics">
<meta property="article:published_time" content="2024-01-01T00:00:00Z">
<meta property="og:title" content="Article Title">
<meta property="og:image" content="https://correiodamanha.com.br/image.jpg">
```

### 6.3 Add Article ID
Add to article pages:

```html
<meta name="article:id" content="12345">
```

Or include in article element:

```html
<article data-article-id="12345">
```

---

## 🌍 Step 7: Configure Custom Domain (Optional)

### 7.1 Add Custom Domain in Render
1. Go to your web service
2. Click "Settings" → "Custom Domains"
3. Add: `analytics.correiodamanha.com.br`

### 7.2 Update DNS
Add CNAME record in your DNS:

```
analytics.correiodamanha.com.br → cm-analytics.onrender.com
```

### 7.3 Update Tracker Script
Once DNS propagates, update portal to use:

```html
<script
  src="https://analytics.correiodamanha.com.br/tracker/tracker.js"
  data-site-id="correio-da-manha"
  async
></script>
```

---

## 🔍 Step 8: Monitor Production

### Check Logs
In Render dashboard → Logs → View streaming logs

### Key Metrics to Monitor
- Event ingestion rate
- Dashboard load times
- Database query performance
- Error rates

---

## 🛠️ Troubleshooting

### Issue: Database Connection Error
**Solution**: 
1. Check DATABASE_URL environment variable
2. Verify Neon database is active
3. Test connection: `bin/rails db:migrate:status`

### Issue: Tracker Script Not Loading
**Solution**:
1. Check public/tracker/tracker.js exists
2. Verify file permissions
3. Check Rails logs for errors

### Issue: CORS Errors
**Solution**:
1. Verify ALLOWED_ORIGINS includes your domain
2. Check CORS initializer configuration
3. Ensure HTTPS is used

### Issue: Events Not Being Saved
**Solution**:
1. Check production logs
2. Verify AnalyticsEvent model validation
3. Test event endpoint manually with curl

---

## 📈 Next Steps

### Phase 2 Enhancements
- [ ] Add Redis for Sidekiq background jobs
- [ ] Implement ClickHouse for analytics
- [ ] Add WebSocket real-time updates
- [ ] Integrate Google Search Console
- [ ] Set up alerting system
- [ ] Add CDN for tracker.js
- [ ] Implement A/B testing
- [ ] Add more security (Rack::Attack)

### Monitoring
- [ ] Set up error tracking (Sentry)
- [ ] Configure uptime monitoring
- [ ] Add performance monitoring
- [ ] Set up alerts

---

## 📞 Support

For issues:
1. Check Render logs
2. Check Neon database status
3. Review this guide
4. Check Rails logs in production

---

## 🔗 Useful Links

- **Render Dashboard**: https://dashboard.render.com
- **Neon Dashboard**: https://console.neon.tech
- **Your App**: https://cm-analytics.onrender.com
- **Your Dashboard**: https://cm-analytics.onrender.com/dashboard

---

**Version**: 1.0.0  
**Last Updated**: 2025-01-10  
**Status**: Production Ready
