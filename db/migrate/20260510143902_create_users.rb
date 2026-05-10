class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.string :password_digest, null: false
      t.string :role, default: 'reporter', null: false
      t.jsonb :permissions, default: {}
      t.datetime :last_sign_in_at
      
      t.timestamps
      
      t.index :email, unique: true
      t.index :role
    end
  end
end
