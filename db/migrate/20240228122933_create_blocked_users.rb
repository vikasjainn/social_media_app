class CreateBlockedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :blocked_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :blocked_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
