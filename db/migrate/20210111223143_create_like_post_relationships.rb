class CreateLikePostRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :like_post_relationships do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
    add_index :like_post_relationships, :post_id
    add_index :like_post_relationships, [:user_id, :created_at]
    add_index :like_post_relationships, [:user_id, :post_id], unique: true
  end
end
