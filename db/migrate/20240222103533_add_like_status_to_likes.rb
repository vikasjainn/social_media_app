class AddLikeStatusToLikes < ActiveRecord::Migration[7.1]
  def change
    add_column :likes, :like_status, :integer
  end
end
