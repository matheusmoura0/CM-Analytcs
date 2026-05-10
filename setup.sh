#!/bin/bash

echo "🚀 Setting up CM Analytics..."
echo ""

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install it first."
    echo "   macOS: brew install postgresql"
    echo "   Ubuntu: sudo apt-get install postgresql"
    exit 1
fi

# Check if Redis is installed
if ! command -v redis-cli &> /dev/null; then
    echo "❌ Redis is not installed. Please install it first."
    echo "   macOS: brew install redis"
    echo "   Ubuntu: sudo apt-get install redis-server"
    exit 1
fi

# Install Ruby gems
echo "📦 Installing gems..."
bundle install

# Create database
echo "🗄️  Creating database..."
bin/rails db:create

# Run migrations
echo "🔄 Running migrations..."
bin/rails db:migrate

# Seed database
echo "🌱 Seeding database..."
bin/rails db:seed

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Start Redis: redis-server"
echo "   2. Start Sidekiq (in a new terminal): bundle exec sidekiq"
echo "   3. Start Rails server: bin/rails server"
echo ""
echo "🔗 Dashboard URL: http://localhost:3000/dashboard"
echo ""
echo "👤 Login credentials:"
echo "   Admin: admin@cmanalytics.pt / admin123"
echo "   Editor: editor@cmanalytics.pt / editor123"
echo "   Reporter: reporter@cmanalytics.pt / reporter123"
echo ""
echo "📊 To add tracking to your site, include:"
echo '   <script src="http://localhost:3000/tracker/tracker.js" data-site-id="demo" async></script>'
