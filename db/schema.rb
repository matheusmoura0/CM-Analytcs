# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_10_150000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ad_metrics", force: :cascade do |t|
    t.bigint "article_id"
    t.integer "clicks"
    t.decimal "cpm", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "impressions"
    t.decimal "revenue", precision: 10, scale: 2
    t.decimal "rpm", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_ad_metrics_on_article_id"
    t.index ["date"], name: "index_ad_metrics_on_date"
  end

  create_table "analytics_events", force: :cascade do |t|
    t.bigint "article_id"
    t.string "author"
    t.string "browser"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "device_type"
    t.string "event_type", null: false
    t.jsonb "metadata", default: {}
    t.string "os"
    t.string "position"
    t.text "referrer"
    t.integer "scroll_depth"
    t.string "section"
    t.string "session_id"
    t.string "site_id"
    t.integer "time_on_page"
    t.text "title"
    t.string "traffic_medium"
    t.string "traffic_source"
    t.datetime "updated_at", null: false
    t.text "url"
    t.index ["article_id", "event_type"], name: "index_analytics_events_on_article_id_and_event_type"
    t.index ["article_id"], name: "index_analytics_events_on_article_id"
    t.index ["author", "event_type"], name: "index_analytics_events_on_author_and_event_type"
    t.index ["author"], name: "index_analytics_events_on_author"
    t.index ["created_at"], name: "index_analytics_events_on_created_at"
    t.index ["device_type"], name: "index_analytics_events_on_device_type"
    t.index ["event_type", "created_at"], name: "index_analytics_events_on_event_type_and_created_at"
    t.index ["event_type"], name: "index_analytics_events_on_event_type"
    t.index ["section", "event_type"], name: "index_analytics_events_on_section_and_event_type"
    t.index ["section"], name: "index_analytics_events_on_section"
    t.index ["session_id", "created_at"], name: "index_analytics_events_on_session_id_and_created_at"
    t.index ["session_id"], name: "index_analytics_events_on_session_id"
    t.index ["site_id"], name: "index_analytics_events_on_site_id"
    t.index ["traffic_medium"], name: "index_analytics_events_on_traffic_medium"
    t.index ["traffic_source", "created_at"], name: "index_analytics_events_on_traffic_source_and_created_at"
    t.index ["traffic_source"], name: "index_analytics_events_on_traffic_source"
  end

  create_table "cached_articles", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.text "image_url"
    t.jsonb "metadata", default: {}
    t.datetime "published_at"
    t.string "section"
    t.string "slug", null: false
    t.text "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_cached_articles_on_author"
    t.index ["published_at"], name: "index_cached_articles_on_published_at"
    t.index ["section"], name: "index_cached_articles_on_section"
    t.index ["slug"], name: "index_cached_articles_on_slug", unique: true
  end

  create_table "discover_metrics", force: :cascade do |t|
    t.bigint "article_id"
    t.integer "clicks", default: 0
    t.datetime "created_at", null: false
    t.decimal "ctr", precision: 5, scale: 2
    t.date "date"
    t.integer "impressions", default: 0
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_discover_metrics_on_article_id"
    t.index ["date"], name: "index_discover_metrics_on_date"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "last_sign_in_at"
    t.string "name"
    t.string "password_digest", null: false
    t.jsonb "permissions", default: {}
    t.string "role", default: "reporter", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end
end
