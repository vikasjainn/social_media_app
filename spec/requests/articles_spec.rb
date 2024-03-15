require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let!(:article) { create(:article, user: user) }
  let!(:valid_params) { attributes_for(:article) }
  let!(:invalid_params) { attributes_for(:article, title: "") }


  describe "POST /articles" do
    context "with valid params" do
      
      it "should return a successful response" do
        article_params = { article: valid_params }
        post "/articles", params: article_params, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["title"]).to eq(valid_params[:title])
      end
    end
    
    context "with invalid params" do
      
      it "should return error" do
        article_params = { article: invalid_params }
        post "/articles", params: article_params, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  
  
  
  describe 'GET /articles' do
    context 'when user is authenticated' do
      
      it 'returns a list of public articles and articles shared by friends' do
        get "/articles", headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      end
    end
    
    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get "/articles"
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  
  
  
  describe 'GET /articles/:id' do
    context 'when the article does not exist' do
      it 'returns not found' do
        get "/articles/invalid_id", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error")
      end
    end
    
    context 'when the article exists but is private' do
      it 'returns unauthorized if the user is friends with the owner of article' do
        article.update(status: 'private')
        get "/articles/#{article.id}"
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("errors")
      end
      
      it 'returns the article if the user is friends with the owner of article' do
        article.update(status: 'private')
        user.friends << article.user
        get "/articles/#{article.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq(article.title)
      end
    end
    
    context 'when the article exists and is public' do
      it 'returns the article' do
        get "/articles/#{article.id}", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq(article.title)
      end
    end
  end
  
  
  describe 'PUT /articles/:id' do
    context 'when user is authorized' do
      context 'with valid params' do
        it 'updates the article' do
          article_params = { article: valid_params }
          patch "/articles/#{article.id}", params: article_params, headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to include('title', 'body')
        end
      end
      
      context 'with invalid params' do
        it 'should return 422 error code' do
          article_params = { article: invalid_params }
          patch "/articles/#{article.id}", headers: { 'Authorization' => "Bearer #{token}" }, params: article_params
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('errors')
        end
      end
    end
    
    context 'when the user is not authorized' do
      it 'should return an unauthorized status code' do
        article_params = { article: valid_params }
        patch "/articles/#{article.id}", params: article_params
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end



  describe "DELETE /articles/:id" do 
    context "when the article exists" do
      
      it "should return a no content status" do
        delete "/articles/#{article.id}", headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:no_content)
      end
      
    end
    
    context "when the article does not exists" do
      
      it "should return an error message of article not found" do
        delete "/articles/403", headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["errors"]).to eq("Article not found")
      end
    end
  end
end