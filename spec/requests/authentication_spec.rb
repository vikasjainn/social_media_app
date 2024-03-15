require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user, email: "brad.pitt@gmail.com", password: "Brad.pitt@403") }

    context "with valid credentials" do
      context "with verified account" do
        before do
          user.account_verification.update(email_confirmed: true)
          post "/login", params: { email: user.email, password: user.password }
        end
        
        it "should return an ok HTTP status" do
          expect(response).to have_http_status(:ok)
        end
  
        it "should return access token and refresh token in response body" do
          expect(JSON.parse(response.body)).to include('access_token', 'refresh_token', 'exp', 'username')
        end
      end
      
      context "with unverified account" do
        before do
          post "/login", params: { email: user.email, password: user.password }
        end
        
        it "should return an unauthorized HTTP status" do
          expect(response).to have_http_status(:unauthorized)
        end
        
        it "should return error message" do
          expect(JSON.parse(response.body)).to include("error")
        end
      end
    end
    
    context "with invalid credentials" do
      before do
        post "/login", params: { email: user.email, password: ".pitt@403" }
      end
      
      it "should return an unauthorized HTTP status" do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it "should return error message" do
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end

  describe "POST /refresh_access_token/:refresh_token" do
    let!(:user) { create(:user) }

    context "with a valid refresh token" do
      before do
        post "/refresh_access_token/#{user.refresh_token}"
      end

      it "should return an ok HTTP status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a new access token" do
        expect(JSON.parse(response.body)).to include('access_token', 'exp')
      end
    end
    
    context "with invalid refresh token" do
      before do
        post "/refresh_access_token/invalid"
      end

      it "should return a not_found HTTP status" do
        expect(response).to have_http_status(:not_found)
      end

      it "should return error message" do
        expect(JSON.parse(response.body)).to include("error")
      end
    end
  end
end
