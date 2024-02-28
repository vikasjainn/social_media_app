# app/models/user.rb
class User < ApplicationRecord
    has_secure_password
    has_many :posts, as: :user, dependent: :destroy
    has_many :comments, as: :user, dependent: :destroy
    has_many :likes, as: :user, dependent: :destroy
  end
  
  # app/models/post.rb
  class Post < ApplicationRecord
    belongs_to :user, polymorphic: true
    has_many :comments, as: :post, dependent: :destroy
    has_many :likes, as: :likeable, dependent: :destroy
  end
  
  # app/models/comment.rb
  class Comment < ApplicationRecord
    belongs_to :user, polymorphic: true
    belongs_to :post, polymorphic: true
    has_many :likes, as: :likeable, dependent: :destroy
  end
  
  # app/models/like.rb
  class Like < ApplicationRecord
    belongs_to :user, polymorphic: true
    belongs_to :likeable, polymorphic: true
  end
  