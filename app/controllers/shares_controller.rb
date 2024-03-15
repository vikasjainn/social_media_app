class SharesController < ApplicationController
  before_action :authorize_request

  def index
    @shares = current_user.shares
    render json: @shares, status: :ok
  end
  
  def create
    @article = Article.find_by(id: params[:article_id])
    friend_id = @article.user_id
    @friend = User.find_by(id: friend_id)
    if @article.status == 'public' && current_user.friends.include?(@friend)
      share = current_user.shares.build(user: current_user, article: @article)
      if share.save
        render json: { message: "Article shared successfully", share: share }, status: :created
      else
        render json: { errors: share.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not friends with the user or you are trying to share private article' }, status: :unauthorized
    end
  end

  def destroy
    @share = current_user.shares.find_by(id: params[:id])
    @share.destroy
    head :no_content
  end
end
