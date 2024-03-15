class Share < ApplicationRecord
  belongs_to :user
  belongs_to :article

  # When this scope is invoked, it returns a collection of shares where the active attribute is true. 
  scope :active, -> { where(active: true) }
end
