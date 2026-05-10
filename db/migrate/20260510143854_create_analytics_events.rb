class CreateAnalyticsEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :analytics_events do |t|
      t.string :event_type, null: false, index: true
      t.bigint :article_id, index: true
      t.text :title
      t.string :author, index: true
      t.string :section, index: true
      t.string :position
      t.text :url
      t.text :referrer
      t.string :traffic_source, index: true
      t.string :traffic_medium, index: true
      t.string :device_type, index: true
      t.string :browser
      t.string :os
      t.string :country
      t.string :city
      t.string :session_id, index: true
      t.integer :scroll_depth
      t.integer :time_on_page
      t.jsonb :metadata, default: {}
      
      t.timestamps
    end
    
    # Composite indexes for common queries
    add_index :analytics_events, [:event_type, :created_at]
    add_index :analytics_events, [:article_id, :event_type]
    add_index :analytics_events, [:author, :event_type]
    add_index :analytics_events, [:section, :event_type]
    add_index :analytics_events, [:traffic_source, :created_at]
    add_index :analytics_events, [:session_id, :created_at]
    add_index :analytics_events, :created_at
  end
end
