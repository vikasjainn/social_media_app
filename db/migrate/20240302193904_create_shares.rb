class CreateShares < ActiveRecord::Migration[7.1]
  def change
    create_table :shares do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
