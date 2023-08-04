module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user
      before_action :set_user, only: [:show, :follow, :unfollow]

      def show
        render json: { user: @user, stats: stats }
      end

      def stats
        { followers: @user.followers.count, followings: @user.followings.count }
      end

      def follow
        follow = @current_user.followings.where(followed_id: @user.id).first_or_initialize
        follow.save
        render json: { count: @current_user.followings.count }, status: :ok
      end

      def unfollow
        follow = @current_user.followings.find_by(follower_id: @user.id)
        follow&.destroy
        render json: { count: @current_user.followings.count }, status: :ok
      end

      private

      def set_user
        @user = User.find_by(id: params[:id])
      end
    end
  end
end
