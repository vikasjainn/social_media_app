class Article < ApplicationRecord
    include Visible

    before_destroy :delete_cloudinary_images
    
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable

    has_many :shares, dependent: :destroy
    has_many :shared_by_users, through: :shares, source: :user

    has_many :images, as: :imageable, dependent: :destroy

    paginates_per 50
    
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }

    def delete_cloudinary_images
        images.each do |image|
          Cloudinary::Uploader.destroy(image.url)
        end
    end
end
