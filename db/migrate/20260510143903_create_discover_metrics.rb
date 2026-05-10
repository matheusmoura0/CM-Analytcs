class CreateDiscoverMetrics < ActiveRecord::Migration[7.2]
  def change
    create_table :discover_metrics do |t|
      t.bigint :article_id
      t.integer :impressions, default: 0
      t.integer :clicks, default: 0
      t.decimal :ctr, precision: 5, scale: 2
      t.date :date
      
      t.timestamps
      
      t.index :article_id
      t.index :date
    end
  end
end
