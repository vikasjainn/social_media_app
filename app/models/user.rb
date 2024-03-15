class User < ApplicationRecord
    include Blockable
    include Friendable
    include TokenManagement
    include Shareable
    include Validatable
    include Creditable

    after_create :create_account_verification

    has_many :articles, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes

    has_one :account_verification, dependent: :destroy


    # Rails built-in method that provides password encryption using bcrypt.
    has_secure_password


    private
        def create_account_verification
            AccountVerification.create(user: self)
            UserMailer.registration_confirmation(self).deliver_now
        end
end
