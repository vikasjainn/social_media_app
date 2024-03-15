class AuthenticationController < ApplicationController
    before_action :authorize_request, except: [:login, :refresh_access_token]

    def login
        @user = User.find_by_email(params[:email])

        if @user&.authenticate(params[:password])
            if @user.account_verification.email_confirmed
                time = Time.now + 24.hours.to_i
                access_token = JsonWebToken.encode(user_id: @user.id, exp: time.strftime("%m-%d-%Y %H:%M"))
                @user.generate_refresh_token
                render json: { access_token: access_token, refresh_token: @user.refresh_token, exp: time.strftime("%m-%d-%Y %H:%M"),
                username: @user.username }, status: :ok
            else
                render json: { error: 'Please verify your account to continue' }, status: :unauthorized
            end
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end


    def refresh_access_token
        user = User.find_by(refresh_token: params[:refresh_token])

        if user
            new_access_token = user.refresh_access_token(params[:refresh_token])
            if new_access_token
                time = Time.now + JsonWebToken::ACCESS_TOKEN_EXPIRY_TIME
                render json: { access_token: new_access_token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
            else
                render json: { error: 'Invalid refresh token' }, status: :unprocessable_entity
            end
        else
            render json: { error: 'User not found' }, status: :not_found
        end
    end

    private
    def login_params
        params.permit(:email, :password)
    end
end
