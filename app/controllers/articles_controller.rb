class ArticlesController < ApplicationController
    before_action :authorize_request
    before_action :find_article, except: [:create, :index, :show]
    
    def index
        friend_ids = current_user.friends.pluck(:id)
        @articles = Article.where(status: 'public').or(Article.where(user_id: friend_ids + [current_user.id])).page(params[:page])
        render json: @articles, show_share_count: true, status: :ok
    end


    def show
        @article = Article.find_by(id: params[:id])
        if @article == nil
            render json: { error: 'Article not found' }, status: :not_found
            return 
        end
        

        if @article.status == 'private' && (!current_user.friends.include?(@article.user) && current_user != @article.user)
            render json: { error: "Not Authorized! You are not friends with #{@article.user.username}!!" }, status: :unauthorized
        else
            if current_user == @article.user || current_user.read_article
                render json: @article, show_comments: true, show_shared_by_users: true, show_images: true, status: :ok
            else
                render json: { message: 'Your free credits have expired. Wait for a day or buy the subscription' }, status: :unprocessable_entity
            end
        end
    end


    def create
        @article = current_user.articles.new(article_params)
        @article.images.build(image_params) if params[:images].present?

        if @article.save
            render json: @article, show_comments: true, show_shared_by_users: true, show_images: true, status: :ok
        else
            render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def update
        @article.update(article_params) if article_params.present?
        if params[:images].present?
            @article.images.destroy_all
            @article.images.build(image_params)
        end
        if @article.save
            render json: @article, show_comments: true, show_shared_by_users: true, show_images: true, status: :ok
        else
            render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def destroy
        delete_cloudinary_images(@article.images)
        @article.destroy
        head :no_content
    end


    private
        def find_article
            @article = current_user.articles.find_by(id: params[:id])
            if @article
                return @article
            else
                render json: { errors: 'Article not found' }, status: :not_found
            end
        end

        def article_params
            params.require(:article).permit(:title, :body, :status)
        end

        def image_params
            images = Array(params.require(:images))
            images.map do |image|
                { url: upload_image(image) }
            end
        end

        def upload_image(image)
            Cloudinary::Uploader.upload(image)['secure_url']
        end

        def delete_cloudinary_images(images)
            begin
                images.each do |image|
                    Cloudinary::Uploader.destroy(image.url)
                end
            rescue CloudinaryException => e
                Rails.logger.error("Error deleting Cloudinary images: #{e.message}")
            end
        end
end
