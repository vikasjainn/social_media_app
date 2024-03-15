module Shareable
    extend ActiveSupport::Concern

    included do 
        has_many :shares, dependent: :destroy
    end
end