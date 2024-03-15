require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create :user }
  let!(:token) { JsonWebToken.encode(user_id: user.id)}
  let!(:valid_params) { attributes_for(:user) }
  let!(:invalid_params) { { name: nil } }


  describe "GET /users" do
    context "when user is authorized" do
      before do
        get '/users', headers: { 'Authorization' => "Bearer #{token}" }
      end

      it 'should return an array' do
        expect(JSON.parse(response.body)).to be_an_instance_of(Array)
      end
  
      it 'should return all the users' do
        expect(JSON.parse(response.body).length).to eq(User.count)
      end
    
      it 'should return an ok HTTP status' do
          expect(response).to have_http_status(:ok)
      end
    end
    
    context "when user is not authorized" do
      before do
        get '/users'
      end
      
      it "should return unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it "should return error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  

  describe "GET /users/:id" do
    context "when user is authorized" do
      before do
        get "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
      end
      
      it 'should return an ok HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it "should return a valid body" do
        expect(JSON.parse(response.body)).to include("username", "email")
      end
    end

    context "when user is not authorized" do
      before do
        get "/users/#{user.id}"
      end

      it "should return unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is not found" do
      before do
        get "/users/nonexistent_user", headers: { 'Authorization' => "Bearer #{token}" }
      end

      it "should return user not found error" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end


  describe "POST /users" do
    context "with valid parameters" do
      before do
        post "/users", params: valid_params
      end

      it "should return a created HTTP status" do
        expect(response).to have_http_status(:created)
      end      
      
      it "should have valid body" do
        expect(JSON.parse(response.body)).to include("username", "email")
      end
    end
  
    context "with invalid parameters" do      
      before do
        post "/users", params: invalid_params
      end
      
      it "should return an unprocessable_entity HTTP status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "should return error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end


  describe 'PUT /users/:id' do    
    context "when user is authorized" do
      context "with valid params" do
        before do
          put "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params
        end

        it "should return ok HTTP status" do
          expect(response).to have_http_status(:ok)
        end      
        
        it "should have valid body" do
          expect(JSON.parse(response.body)).to include("username", "email")
        end
      end

      context "with invalid params" do
        before do
          put "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }, params: invalid_params
        end

        it "should return 422 error code" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return error message" do
          expect(JSON.parse(response.body)).to include("errors")
        end
      end
    end

    context 'when the user is not authorized' do
      before do
        put "/users/#{user.id}", params: invalid_params
      end

      it 'should return an unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end

      it "should return error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  
  
  describe 'DELETE /users/:id' do
    context 'when the user is authenticated and authorized' do
      before do
        delete "/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
      end
      
      it 'should return a no content response' do
        expect(response).to have_http_status(:no_content)
      end
      
      it 'should delete the user' do
        expect(User.exists?(user.id)).to be_falsey
      end
    end
    
    context 'when the user is not authorized' do
      before do
        delete "/users/#{user.id}"
      end
      
      it 'should return an unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it "should return error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
end
