class AddSiteIdToAnalyticsEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :analytics_events, :site_id, :string
    add_index :analytics_events, :site_id
  end
end
