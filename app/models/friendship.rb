class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, uniqueness: { scope: :friend_id, message: "already has a friendship with this user" }

    def update_shared_articles_status
      if status == "pending" || status == "declined"
        shares = Share.where(user_id: user_id, article_id: friend.articles.pluck(:id))
        shares.update_all(active: false)
      elsif status == "accepted"
        shares = Share.where(user_id: user_id, article_id: friend.articles.pluck(:id))
        shares.update_all(active: true)
      end
    end
end
