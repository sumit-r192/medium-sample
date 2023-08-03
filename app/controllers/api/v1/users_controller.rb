module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user, only: [:show, :follow, :unfollow]

      def show
        render json: @user
      end

      def follow
        current_user.followed_users << @user
        render json: @user, status: :ok
      end

      def unfollow
        current_user.followed_users.delete(@user)
        render json: @user, status: :ok
      end

      # ...
    end
  end
end
