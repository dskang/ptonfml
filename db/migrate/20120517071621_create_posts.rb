class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
