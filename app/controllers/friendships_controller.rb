class FriendshipsController < ApplicationController
    before_action :authorize_request
    before_action :set_friend, except: :index

    # All friends
    def index
        @friends = current_user.friends
        render json: @friends, show_friend_status: true, status: :ok
    end
    
    # Send friend request
    def create
        if is_user_blocked(@friend)
            render json: { error: 'User not found ~X<o>X~' }, status: :unprocessable_entity
        elsif current_user.friendships.where(friend_id: @friend.id, status: "declined").exists?
            declined_friendship = current_user.friendships.where(friend_id: @friend.id, status: "declined").order(cooldown: :desc).first
            if declined_friendship.cooldown.present? && declined_friendship.cooldown > 30.days.ago
                render json: { error: "Cannot send friend request yet. Cooldown period active" }, status: :unprocessable_entity
            else
                declined_friendship.update(status: "pending", cooldown: nil)
                render json: { message: "Friend request sent to #{@friend.username}" }, status: :created
            end
        else
            @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: "pending")
            if @friendship.save
                render json: { message: "Friend request sent to #{@friend.username}" }, status: :created
            else
                render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    # Accept friend request
    def update
        @friendship = current_user.inverse_friendships.find_by(user: @friend)
        if @friendship.update(status: "accepted")
            @friendship.update_shared_articles_status
            render json: { message: "Friend request from #{@friend.username} accepted" }, status: :ok
        else
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # Reject friend request
    def reject
        @friendship = current_user.inverse_friendships.find_by(user: @friend)
        if @friendship.update(status: "declined")
            @friendship.update(cooldown: 30.days.from_now)
            @friendship.update_shared_articles_status
            render json: { message: "Friend request from #{@friend.username} declined" }, status: :ok
        else
            render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
        end
    end

    
    def pending_requests
        pendin_requests = current_user.inverse_friendships.where(status: "pending")
        render json: pendin_requests, status: :ok
    end


    private
        def set_friend
            @friend = User.find_by(id: params[:friend_id])
        end

        def is_user_blocked(friend)
            if current_user.blocked_users.exists?(blocked_user_id: friend.id) || friend.blocked_users.exists?(blocked_user_id: current_user.id)
                return true
            end
            return false
        end
end