module Blockable
    extend ActiveSupport::Concern

    included do 
        has_many :blocked_users
        has_many :blocked, through: :blocked_users, source: :blocked_user
        has_many :inverse_blocked_users, class_name: 'BlockedUser', foreign_key: 'blocked_user_id'
        has_many :inverse_blocked, through: :inverse_blocked_users, source: :user
    end
end