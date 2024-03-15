class AddCreditsAndPremiumToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :credits, :integer, default: 10
    add_column :users, :premium, :boolean, default: false
  end
end
