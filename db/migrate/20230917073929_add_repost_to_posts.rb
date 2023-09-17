class AddRepostToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :repost_id, :integer
  end
end
