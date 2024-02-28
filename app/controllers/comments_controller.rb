# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
    before_action :require_login, only: [:create, :destroy]
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to @post, notice: 'Comment successfully created!'
      else
        redirect_to @post, alert: 'Error creating comment.'
      end
    end
  
    def destroy
      @comment = current_user.comments.find(params[:id])
      @comment.destroy
      redirect_to root_path, notice: 'Comment successfully deleted!'
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  