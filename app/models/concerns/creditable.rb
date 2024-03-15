module Creditable
    extend ActiveSupport::Concern


    def self.reset_credits
        User.where(premium: false).update_all(credits: 10)
    end

    def read_article
        if credits > 0 || premium
            decrement!(:credits) unless premium
            true
        else
            false
        end
    end

end