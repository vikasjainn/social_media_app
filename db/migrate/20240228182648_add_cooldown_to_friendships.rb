class AddCooldownToFriendships < ActiveRecord::Migration[7.1]
  def change
    add_column :friendships, :cooldown, :datetime
  end
end
