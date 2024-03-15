require 'rails_helper'

RSpec.describe "AccountVerifications", type: :request do
  describe "GET /account_verification/:confirm_token" do
    let!(:account_verification) { create(:account_verification) }

    context "with a valid confirm token" do
      before do
        get "/account_verification/#{account_verification.confirm_token}"
      end

      it "should confirm the email and clear the confirmation token" do
        account_verification.reload
        expect(account_verification.email_confirmed).to eq(true)
        expect(account_verification.confirm_token).to be_nil
      end

      it "should return an ok status code" do
        expect(response).to have_http_status(:ok)
      end

      it "should return a success message" do
        expect(JSON.parse(response.body)['message']).to eq('Your email has been confirmed successfully!')
      end
    end

    context "with an invalid confirmation token" do
      before do
        get "/account_verification/invalid_token"
      end

      it "should return an unprocessable entity HTTP status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should return an error message" do
        expect(JSON.parse(response.body)['error']).to eq('Invalid Request')
      end
    end
  end
end
