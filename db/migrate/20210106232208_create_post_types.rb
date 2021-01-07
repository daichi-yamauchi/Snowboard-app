class CreatePostTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :post_types do |t|
      t.string :name
      t.string :name_j

      t.timestamps
    end
  end
end
