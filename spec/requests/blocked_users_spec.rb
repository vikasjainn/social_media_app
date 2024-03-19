require 'rails_helper'

RSpec.describe "BlockedUsers", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  describe "GET /blocked_users" do
    it "returns a list of blocked users" do
      blocked_users = FactoryBot.create_list(:blocked_user, 5, user: user)
      get '/blocked_users', headers: { 'Authorization': "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      expect(JSON.parse(response.body).length).to eq(5)
    end
  end


  describe "POST /blocked_users/:user_id" do
    context "when the user is not already blocked" do
      
      it "blocks the user successfully" do
        post "/blocked_users/#{other_user.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("User blocked successfully")
      end
    end

    context "when the user is already blocked" do
      
      it "returns unprocessable entity status" do
        user.blocked_users.create(blocked_user_id: other_user.id)
        post "/blocked_users/#{other_user.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("User is already blocked")
      end
    end
  end


  describe "DELETE /blocked_users/:user_id" do
    context "when the user is blocked" do
      
      it "unblocks the user successfully" do
        create(:blocked_user, user: user, blocked_user: other_user)
        delete "/blocked_users/#{other_user.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user is not blocked" do
      it "returns not found status" do
        delete "/blocked_users/#{other_user.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("User is not blocked")
      end
    end
  end
end