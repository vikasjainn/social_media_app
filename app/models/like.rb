class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  # This validation ensures that a user can only like a specific object once
  validates :user_id, uniqueness: { scope: [:likeable_id, :likeable_type] }
end
