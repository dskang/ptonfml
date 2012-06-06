class AddPhoneToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :phone, :string
  end
end
