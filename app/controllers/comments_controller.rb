class CommentsController < ApplicationController
    before_action :authorize_request
    before_action :find_comment, only: [:update, :destroy]


    def index
      @article = current_user.articles.find_by(id: params[:article_id])
      @comments = @article.comments.all
      render json: @comments, status: :ok
    end
    

    def create
      @article = current_user.articles.find_by(id: params[:article_id])

      if @article.nil?
        render json: { errors: ['Article not found'] }, status: :not_found
        return
      end

      @comment = @article.comments.new(comment_params)
      @comment.commenter = current_user.username
      @comment.images.build(image_params) if params[:images].present?

      if @comment.save
        render json: @comment, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end


    def update
    if current_user.username == @comment.commenter
      if @comment.update(comment_params)
        if params[:images].present?
          @comment.images.destroy_all
          @comment.images.build(image_params)
        end

        if @comment.save
          render json: @comment, status: :ok
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['You are not authorized to update this comment'] }, status: :unauthorized
    end
  end


  def destroy
    if current_user.username == @comment.commenter
      delete_cloudinary_images(@comment.images)
      @comment.destroy
      head :no_content
    else
      render json: { errors: ['You are not authorized to delete this comment'] }, status: :unauthorized
    end
  end

  
  private
  
  def find_comment
    @comment = Comment.find_by(id: params[:id])
    render json: { errors: ['Comment not found'] }, status: :not_found if @comment.nil?
  end

  def comment_params
    params.require(:comment).permit(:body, :status)
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
  