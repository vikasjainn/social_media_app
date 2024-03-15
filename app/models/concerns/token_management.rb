module TokenManagement
    extend ActiveSupport::Concern
  
    included do
      def refresh_access_token(refresh_token)
        if self.refresh_token == refresh_token && refresh_token_valid?
          self.generate_refresh_token
          time = Time.now + 24.hours.to_i
          JsonWebToken.encode(user_id: self.id , exp: time.strftime("%m-%d-%Y %H:%M"))
        else
          nil
        end
      end

      def generate_refresh_token
        self.refresh_token = SecureRandom.hex(20)
        self.save
      end
  
      private
  
      def refresh_token_valid?
        Time.now < (self.created_at + JsonWebToken::REFRESH_TOKEN_EXPIRY_TIME)
      end
    end
  
  end
  