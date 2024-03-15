class BlockedUsersController < ApplicationController
  before_action :authorize_request
  before_action :set_blocked_user, only: [:create, :destroy]


  def index 
    @blocked_users = current_user.blocked
    render json: @blocked_users, status: :ok
  end


  def create
    if current_user.blocked_users.exists?(blocked_user_id: @blocked_user.id)
      render json: { error: 'User is already blocked' }, status: :unprocessable_entity
    else
      blocked_user = current_user.blocked_users.build(blocked_user_id: @blocked_user.id)
      if blocked_user.save
        remove_blocked_user_from_friend_lists(current_user, @blocked_user)
        render json: { message: 'User blocked successfully' }, status: :ok
      else
        render json: { errors: blocked_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end


  def destroy
    blocked_user = current_user.blocked_users.find_by(blocked_user_id: @blocked_user.id)
    if blocked_user
      blocked_user.destroy
      render json: { message: 'User unblocked successfully' }
      head :no_content
    else
      render json: { error: 'User is not blocked' }, status: :not_found
    end
  end

  private
  
    def set_blocked_user
      @blocked_user = User.find_by(id: params[:user_id])
      render json: { error: 'User not found' }, status: :not_found unless @blocked_user
    end

    def remove_blocked_user_from_friend_lists(user1, user2)
      user1.friends.delete(user2)
      user2.friends.delete(user1)
    end

end
