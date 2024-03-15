class ShareSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :article_id, :shared_by, :owned_by, :active

  def shared_by
    user = User.find_by(id: object.user_id)
    user.username
  end
  
  def owned_by
    user = User.find_by(id: object.article.user_id)
    user.username
  end
end
