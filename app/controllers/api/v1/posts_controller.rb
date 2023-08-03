module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_post, only: [:show, :update, :destroy]

      def index
        @posts = Post.all
        render json: @posts
      end

      def show
        render json: @post
      end

      def create
        @post = current_user.posts.build(post_params)
        if @post.save
          render json: @post, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          render json: @post
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy
        head :no_content
      end

      def like
        @post.likes.create(user: current_user)
        render json: @post, status: :ok
      end

      def unlike
        @post.likes.where(user_id: current_user.id).destroy_all
        render json: @post, status: :ok
      end

      def top_posts
        top_posts = Post.joins(:likes, :comments)
                       .select('posts.*, COUNT(DISTINCT likes.id) AS total_likes, COUNT(DISTINCT comments.id) AS total_comments')
                       .group('posts.id')
                       .order('total_likes DESC, total_comments DESC')
                       .limit(10)

        render json: top_posts, status: :ok
      end

      def recommended_posts
        user_following_ids = current_user.followed_users.pluck(:id)

        recommended_posts = Post.joins(:likes)
                                .where(likes: { user_id: user_following_ids })
                                .select('posts.*, COUNT(DISTINCT likes.id) AS total_likes')
                                .group('posts.id')
                                .order('total_likes DESC')
                                .limit(10)

        render json: recommended_posts, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content, :status)
      end
    end
  end
end
