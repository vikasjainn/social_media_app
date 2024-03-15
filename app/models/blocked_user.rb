class BlockedUser < ApplicationRecord
  belongs_to :user
  belongs_to :blocked_user, class_name: "User"

  
  validates :user_id, presence: true
  validates :blocked_user_id, presence: true
  validate :not_blocking_self

  private
    def not_blocking_self
      errors.add(:base, "You cannot block yourself") if user_id == blocked_user_id
    end
end
