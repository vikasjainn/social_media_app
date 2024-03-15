class CreateAccountVerifications < ActiveRecord::Migration[7.1]
  def change
    create_table :account_verifications do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :email_confirmed, default: false
      t.string :confirm_token

      t.timestamps
    end
  end
end
