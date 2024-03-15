class AccountVerification < ApplicationRecord
  before_create :generate_confirmation_token
  
  belongs_to :user


  private
    def generate_confirmation_token
      if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
