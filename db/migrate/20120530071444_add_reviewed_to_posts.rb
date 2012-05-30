class AddReviewedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :reviewed, :boolean, default: false
  end
end
