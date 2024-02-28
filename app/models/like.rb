# app/models/like.rb
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  enum like_status: { like: 0, dislike: 1 }
end
