class UserMailer < ApplicationMailer
    def password_reset(user, otp)
        @user = user
        @otp = otp
        mail(to: @user.email, subject: 'Password Reset')
    end

    def registration_confirmation(user)
        @user = user
        mail(to: @user.email, subject: "Account Verification")
    end
end
