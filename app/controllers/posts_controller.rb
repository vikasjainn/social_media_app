# app/controllers/posts_controller.rb
class PostsController < ApplicationController
    before_action :require_login, only: [:new, :create, :destroy]
  
    def index
      @posts = Post.all
    end
  
    def new
      @post = current_user.posts.build
    end
  
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to root_path, notice: 'Post successfully created!'
      else
        render 'new'
      end
    end
  
    def show
      @post = Post.find(params[:id])
      @comments = @post.comments
      @comment = Comment.new
      @likeable = @post
      @likes = @post.likes.where(like_status: :like)
      @dislikes = @post.likes.where(like_status: :dislike)
      @like = Like.new
    end
  
    
  
    def destroy
      @post = current_user.posts.find(params[:id])
      @post.destroy
      redirect_to root_path, notice: 'Post successfully deleted!'
    end
  
    private
  
    def post_params
      params.require(:post).permit(:content)
    end
  
    def require_login
      unless current_user
        flash[:alert] = 'You must be logged in to access this page.'
        redirect_to login_path
      end
    end
  end
  