# app/controllers/likes_controller.rb
class LikesController < ApplicationController
    before_action :require_login
  
    def create
      @likeable = find_likeable
      @like = @likeable.likes.build(user: current_user, like_status: :like)
  
      if @like.save
        redirect_to root_path, notice: 'Like added!'
      else
        redirect_to root_path, alert: 'Error adding like.'
      end
    end
  
    def destroy
      @likeable = find_likeable
      @like = @likeable.likes.find_by(user: current_user)
  
      if @like.destroy
        redirect_to root_path, notice: 'Like removed!'
      else
        redirect_to root_path, alert: 'Error removing like.'
      end
    end
  
    private
  
    def find_likeable
      if params[:post_id]
        Post.find(params[:post_id])
      elsif params[:comment_id]
        Comment.find(params[:comment_id])
      else
        # Handle the case when no valid likeable is found
      end
    end
  end
  