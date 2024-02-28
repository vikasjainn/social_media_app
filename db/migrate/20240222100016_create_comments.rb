class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, polymorphic: true, null: false
      t.references :post, polymorphic: true, null: false

      t.timestamps
    end
  end
end
