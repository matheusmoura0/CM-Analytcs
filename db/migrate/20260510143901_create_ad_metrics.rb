class CreateAdMetrics < ActiveRecord::Migration[7.2]
  def change
    create_table :ad_metrics do |t|
      t.bigint :article_id
      t.decimal :revenue, precision: 10, scale: 2
      t.decimal :rpm, precision: 10, scale: 2
      t.decimal :cpm, precision: 10, scale: 2
      t.integer :impressions
      t.integer :clicks
      t.date :date
      
      t.timestamps
      
      t.index :article_id
      t.index :date
    end
  end
end
