class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :article_count, :profile_pic, :cover_pic, :credits, :premium

  has_many :articles, if: -> {@instance_options[:show_articles]}

  attribute :friend_status, if: -> { @instance_options[:show_friend_status] }

  attribute :refresh_token, if: -> { @instance_options[:show_refresh_token] }

  def article_count
    object.articles.count
  end

  def friend_status
    friendship = Friendship.find_by(user: current_user, friend: object)
    friendship.status
  end
end
