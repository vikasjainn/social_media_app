class AccountVerificationsController < ApplicationController
  def confirm_email
    account_verification = AccountVerification.find_by(confirm_token: params[:confirm_token])

    if account_verification
      account_verification.update(email_confirmed: true, confirm_token: nil)
      render json: { message: "Your email has been confirmed successfully!" }, status: :ok
    else
      render json: { error: "Invalid Request" }, status: :unprocessable_entity
    end
  end
end
