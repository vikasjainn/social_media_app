require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:article) { create(:article) }
  let(:comment) { create(:comment, article: article) }
  let(:like) { create(:like, user: user) }


  describe "POST /articles/:article_id/likes" do
    context "with valid params" do
      it "should return created response" do
        post "/articles/#{article.id}/likes", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end
    
    context "when not authorized" do
      it "should return error message" do
        post "/articles/#{article.id}/likes"

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  
  
  describe "POST /comments/:comment_id/likes" do
    context "with valid params" do
      it "should return created response" do
        post "/comments/#{comment.id}/likes", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end
    
    context "when not authorized" do
      it "should return error message" do
        post "/comments/#{comment.id}/likes"
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  
  
  describe "GET /articles/:article_id/likes" do
    context "with valid params" do
      it "should return created response" do
        get "/articles/#{article.id}/likes", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      end
    end
    
    context "with invalid params" do
      it "should return error message" do
        get "/articles/123jahhbdkj/likes", headers: { 'Authorization': "Bearer #{token}" }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["errors"]).to include("Article not found")
      end
    end
  end


  describe "GET /comments/:comment_id/likes" do
    context "with valid params" do
      it "should return created response" do
        get "/comments/#{comment.id}/likes", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      end
    end
    
    context "with invalid params" do
      it "should return error message" do
        get "/comments/12ekajsdnk/likes", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["errors"]).to include("Comment not found")
      end
    end
  end


  describe "DELETE /likes/:id" do     
    context "when the like exists" do
      it "should delete the like" do
        delete "/likes/#{like.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:no_content)
      end
    end
    
    context "when the like does not exist" do
      it "should return a not found status" do
        delete "/likes/1243hbjda", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Like not found or you don't have permission to delete it")
      end
    end
  end
end