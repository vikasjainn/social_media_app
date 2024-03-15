class LikesController < ApplicationController
  before_action :authorize_request

  def article_likes 
    @article = Article.find_by(id: params[:article_id])
    likes = @article.likes
    render json: likes, status: :ok
  end
  
  def comment_likes 
    @comment = Comment.find_by(id: params[:comment_id])
    likes = @comment.likes
    render json: likes, status: :ok
  end

  def create
    @likeable = find_likeable
    @like = @likeable.likes.new(user_id: current_user.id)
    if @like.save
      render json: @likeable, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end


  def destroy
    @like = Like.find_by(id: params[:id], user_id: current_user.id)
    if @like
      @like.destroy
      head :no_content
    else
      render json: { error: "Like not found or you don't have permission to delete it" }, status: :not_found
    end
  end


  private
    def find_likeable
      if params[:article_id]
        Article.find(params[:article_id])
      elsif params[:comment_id]
        Comment.find(params[:comment_id])
      end
    end
end
