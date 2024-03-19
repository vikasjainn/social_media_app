require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let(:comment) { create(:comment, article: article, user: user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let!(:valid_params) { attributes_for(:comment) }
  let!(:invalid_params) { attributes_for(:comment, body: "") }
  

  describe "GET /articles/:article_id/comments" do
    context 'when article exists' do
      it 'should return a success response' do
        get "/articles/#{article.id}/comments", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(article.comments.count)
      end
    end
    
    context 'when article does not exists' do
      it 'should return a success response' do
        get "/articles/xyzad/comments", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Article not found')
      end
    end
  end
  
  
  describe "POST /articles/:article_id/comments" do
    context "when the article exists" do
      context "with valid params" do
        it "should return a successful response" do
          comment_params = { comment: valid_params }
          post "/articles/#{article.id}/comments", params: comment_params, headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)["body"]).to eq(valid_params[:body])
        end
      end
      
      context "with invalid params" do
        it "should return error" do
          comment_params = { comment: invalid_params }
          post "/articles/#{article.id}/comments", params: comment_params, headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("errors")
        end
      end
    end
    
    context "when the article does not exists" do
      it 'returns not found' do
        comment_params = { comment: valid_params }
        post "/articles/xyzabcaeejdf/comments", params: comment_params, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end


  describe "GET /comments/:id" do
    context "when the comment exists" do
      context 'when current user is the commenter' do      
        it 'returns a success response' do
          get "/comments/#{comment.id}", headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(comment.id)
        end
      end
      
      context 'when current user is not the commenter' do
        let(:other_user) { create(:user) }
        let(:other_token) { JsonWebToken.encode(user_id: other_user.id) }
        
        it 'returns an unauthorized response' do
          get "/comments/#{comment.id}", headers: { 'Authorization': "Bearer #{other_token}" }
          
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
        end
      end
    end
    
    context "when the comment does not exists" do
      it 'returns not found error' do
        get "/comments/abc123", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end



  describe "PATCH /comments/:id" do
    context "when the comment exists" do
      context 'when current user is the commenter' do      
        it 'returns a success response' do
          comment_params = { comment: valid_params }
          patch "/comments/#{comment.id}", params: comment_params, headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['id']).to eq(comment.id)
        end
      end
      
      context 'when current user is not the commenter' do
        let(:other_user) { create(:user) }
        let(:other_token) { JsonWebToken.encode(user_id: other_user.id) }
        
        it 'returns an unauthorized response' do
          comment_params = { comment: valid_params }
          patch "/comments/#{comment.id}", params: comment_params, headers: { 'Authorization': "Bearer #{other_token}" }
          
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['errors']).to include('You are not authorized to update this comment')
        end
      end
    end
    
    context "when the comment does not exists" do
      it 'returns not found error' do
        comment_params = { comment: valid_params }
        patch "/comments/abc123", params: comment_params, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end


  describe "DELETE /comments/:id" do
    context "when the comment exists" do
      context 'when current user is the commenter' do      
        it 'returns a success response' do
          delete "/comments/#{comment.id}", headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:no_content)
        end
      end
      
      context 'when current user is not the commenter' do
        let(:other_user) { create(:user) }
        let(:other_token) { JsonWebToken.encode(user_id: other_user.id) }
        
        it 'returns an unauthorized response' do
          delete "/comments/#{comment.id}", headers: { 'Authorization': "Bearer #{other_token}" }
          
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['errors']).to include('You are not authorized to delete this comment')
        end
      end
    end
    
    context "when the comment does not exist" do
      it 'returns not found error' do
        delete "/comments/abc123", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end  
end