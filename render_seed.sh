#!/bin/bash
# Script to seed the database on Render
# Run this in the Render Console

echo "Seeding database..."
rails db:seed

echo "✅ Database seeded!"
echo ""
echo "📝 Login credentials:"
echo "   Admin: admin@cmanalytics.pt / admin123"
echo "   Editor: editor@cmanalytics.pt / editor123"
echo "   Reporter: reporter@cmanalytics.pt / reporter123"
