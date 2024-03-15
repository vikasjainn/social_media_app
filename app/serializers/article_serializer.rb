class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :status, :username, :like_count, :comment_count

  has_many :comments, if: -> {@instance_options[:show_comments]}
  has_many :images, if: -> {@instance_options[:show_images]}

  attribute :shared_by_users, if: -> {@instance_options[:show_shared_by_users]}
  attribute :share_count, if: -> {@instance_options[:show_share_count]}
  
  def username
    object.user.username
  end

  def like_count
    object.likes.count
  end
  
  def comment_count
    object.comments.count
  end

  def shared_by_users
    object.shared_by_users
  end

  def share_count
    object.shares.active.count
  end
end
