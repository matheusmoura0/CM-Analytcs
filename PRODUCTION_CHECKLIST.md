# CM Analytics - Production Deployment Checklist

## ✅ Pre-Deployment Checklist

### Code Ready
- [x] Removed localhost references from tracker.js
- [x] Added site_id field to analytics_events
- [x] Updated CORS for production domains
- [x] Created production environment configuration
- [x] Added Procfile for Render deployment
- [x] Configured Puma for production
- [x] Created render.yaml configuration

### Database
- [x] Created Neon PostgreSQL database
- [x] Added DATABASE_URL to environment variables
- [x] Ran database migrations
- [x] Seeded initial users

### Security
- [x] Force SSL enabled in production
- [x] Allowed hosts configured
- [x] CORS properly configured
- [x] Secret key base generated
- [x] CSRF protection enabled
- [x] Session-based authentication

### API Endpoints
- [x] POST /api/v1/analytics/events (public)
- [x] POST /api/v1/analytics/batch (public)
- [x] GET /tracker/tracker.js (public)
- [x] GET /health (public)
- [x] GET /dashboard (authenticated)
- [x] GET /dashboard/realtime (authenticated)
- [x] GET /dashboard/editorial (authenticated)
- [x] GET /dashboard/discover (authenticated)
- [x] GET /dashboard/monetization (authenticated)

---

## 🚀 Deployment Steps

### 1. Push to GitHub
```bash
cd /Users/matheusoliveira/Desktop/CM-Analytics
git add .
git commit -m "Production ready - Render deployment"
git push origin main
```

### 2. Deploy to Render
1. Go to https://render.com
2. Create new Web Service
3. Connect GitHub repository
4. Configure settings (see RENDER_DEPLOYMENT.md)
5. Deploy!

### 3. Run Migrations
```bash
# In Render Shell
bundle exec rails db:migrate
bundle exec rails db:seed
```

### 4. Validate
```bash
# Health check
curl https://cm-analytics.onrender.com/health

# Test tracker
curl https://cm-analytics.onrender.com/tracker/tracker.js

# Test event
curl -X POST https://cm-analytics.onrender.com/api/v1/analytics/events \
  -H "Content-Type: application/json" \
  -d '{"site_id":"correio-da-manha","event":"page_view","url":"https://test.com"}'
```

---

## 🔌 Portal Integration

### Add to Portal Head
```html
<script
  src="https://cm-analytics.onrender.com/tracker/tracker.js"
  data-site-id="correio-da-manha"
  async
></script>
```

### Required Metadata
```html
<meta property="article:author" content="">
<meta property="article:section" content="">
<meta property="article:published_time" content="">
<meta property="og:title" content="">
<meta property="og:image" content="">
<meta name="article:id" content="">
```

---

## 📊 Post-Deployment Validation

### 1. Tracker Loading
- [ ] Browser DevTools Network tab shows tracker.js loading
- [ ] No CORS errors
- [ ] No mixed content errors

### 2. Event Tracking
- [ ] Events appear in database
- [ ] Dashboard shows real-time data
- [ ] Traffic sources correctly identified

### 3. Dashboard Access
- [ ] Login page works
- [ ] Dashboard loads after login
- [ ] All sections accessible

### 4. Performance
- [ ] Page load time < 3 seconds
- [ ] Event API responds < 500ms
- [ ] Dashboard queries < 2 seconds

---

## 🔧 Configuration Files

### Environment Variables (Render)
```
RAILS_ENV=production
SECRET_KEY_BASE=<generated>
DATABASE_URL=<neon_url>
ALLOWED_ORIGINS=https://www.correiodamanha.com.br,https://correiodamanha.com.br
APP_HOST=cm-analytics.onrender.com
DEFAULT_SITE_ID=correio-da-manha
```

### Files Created
- `render.yaml` - Render deployment config
- `Procfile` - Process configuration
- `config/puma.rb` - Puma server config
- `config/environments/production.rb` - Production settings
- `config/initializers/cors.rb` - CORS configuration
- `public/tracker/tracker.js` - Production tracker script

---

## 🎯 Production URLs

### Temporary (Render)
- App: https://cm-analytics.onrender.com
- Tracker: https://cm-analytics.onrender.com/tracker/tracker.js
- API: https://cm-analytics.onrender.com/api/v1/analytics/events
- Dashboard: https://cm-analytics.onrender.com/dashboard

### Future (Custom Domain)
- App: https://analytics.correiodamanha.com.br
- Tracker: https://analytics.correiodamanha.com.br/tracker/tracker.js
- API: https://analytics.correiodamanha.com.br/api/v1/analytics/events
- Dashboard: https://analytics.correiodamanha.com.br/dashboard

---

## 📱 Test with Real Portal

1. Add script to one article page
2. Open article in browser
3. Check DevTools Network tab
4. Verify events are sent
5. Check dashboard for data

---

## 🚨 Troubleshooting

### Tracker Not Loading
- Check file permissions
- Verify URL is correct
- Check Rails logs
- Test with curl

### Events Not Saving
- Check event format
- Verify API endpoint
- Check database connection
- Review error logs

### Dashboard Not Loading
- Clear browser cache
- Check authentication
- Verify database migrations
- Check Rails logs

---

## 📈 Monitoring

### Key Metrics
- Events per minute
- Active users
- Dashboard load time
- Error rate
- Database query time

### Logs Location
- Render Dashboard → Logs
- Rails logs: log/production.log

---

## 🎉 Success Criteria

✅ Production accessible at https://cm-analytics.onrender.com  
✅ Tracker script loads on portal  
✅ Events are captured and stored  
✅ Dashboard displays real data  
✅ All features working in production  

---

**Ready to deploy! 🚀**
