class Comment < ApplicationRecord
  include Visible
  
  belongs_to :article
  belongs_to :user
  has_many :likes, as: :likeable
  has_many :images, as: :imageable, dependent: :destroy
end
