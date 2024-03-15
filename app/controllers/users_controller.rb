class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: [:create, :index]
    
    def index
        @users = User.all
        render json: @users, status: :ok
    end


    def show
        if @user == current_user
            render json: @user, show_articles: true, show_refresh_token: true, status: :ok
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end

   
    def create
        @user = User.new(user_params)
        @user.profile_pic = upload_picture(params[:profile_pic]) if params[:profile_pic].present?
        @user.cover_pic = upload_picture(params[:cover_pic]) if params[:cover_pic].present?

        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    
    def update
        if @user == current_user
            if @user.update(user_params)
                @user.profile_pic = upload_picture(params[:profile_pic]) if params[:profile_pic].present?
                @user.cover_pic = upload_picture(params[:cover_pic]) if params[:cover_pic].present?
                @user.save
                render json: @user, status: :ok
            else
                render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
    
    
    def destroy
        if @user == current_user
            delete_cloudinary_images(@user)
            @user.destroy
            head :no_content
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
    
    
    private
    def find_user
        @user = User.find_by(id: params[:id])
        render json: { errors: 'User not found' }, status: :not_found unless @user
    end

    def user_params
        params.permit(
        :name, :username, :email, :password, :password_confirmation, :profile_pic, :cover_pic
        )
    end

    def upload_picture(picture)
        uploaded_picture = Cloudinary::Uploader.upload(picture)
        uploaded_picture['secure_url']
    end

    def delete_cloudinary_images(user)
        begin
            Cloudinary::Uploader.destroy(user.profile_pic) if user.profile_pic.present?
            Cloudinary::Uploader.destroy(user.cover_pic) if user.cover_pic.present?
        rescue CloudinaryException => e
            Rails.logger.error("Error deleting Cloudinary images: #{e.message}")
        end
    end
end
