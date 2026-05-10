class CreateCachedArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :cached_articles, id: :bigserial, primary_key: :id do |t|
      t.text :title, null: false
      t.string :slug, null: false
      t.string :author
      t.string :section
      t.text :image_url
      t.datetime :published_at
      t.jsonb :metadata, default: {}
      
      t.timestamps
    end
    
    add_index :cached_articles, :slug, unique: true
    add_index :cached_articles, :author
    add_index :cached_articles, :section
    add_index :cached_articles, :published_at
  end
end
