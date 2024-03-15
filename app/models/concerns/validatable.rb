module Validatable
    extend ActiveSupport::Concern

    included do 
        validates :name, presence: true, length: { in: 2..50 }
        validates :email, presence: true, uniqueness: true
        validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
        validates :username, presence: true, uniqueness: true
        
        validates :password,
            presence: true,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }

        validate :password_format
    end

    private

    def password_format
        # Using regular expression
        # if password.present? && !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/)
        #     errors.add :password, "Must contain at least one uppercase letter, one lowercase letter, one number, and one special character"
        # end

        if password.present?
            is_uppercase = false
            is_lowercase = false
            is_number = false
            is_special = false
            
            password.each_char do |char|
                if ('A'..'Z').include?(char)
                    is_uppercase = true
                elsif ('a'..'z').include?(char)
                    is_lowercase = true
                elsif ('0'..'9').include?(char)
                    is_number = true
                else
                    is_special = true
                end
            end

            
            errors.add :password, "Must contain at least one uppercase letter" unless is_uppercase    
            errors.add :password, "Must contain at least one lowercase letter" unless is_lowercase
            errors.add :password, "Must contain at least one digit" unless is_number
            errors.add :password, "Must contain at least one special character" unless is_special
        end
    end
end