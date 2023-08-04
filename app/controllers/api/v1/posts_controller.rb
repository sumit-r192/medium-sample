module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user, except: [:index, :show]
      before_action :set_post, only: [:show, :update, :destroy, :like, :unlike, :more_posts_by_similar_author, :save_for_later, :unsave, :stats]

      def author_posts
        @posts = @@current_user.posts
        render json: @posts
      end

      # Query searched from google
      def index
          if params[:sort_by] == 'likes'
          @posts = Post.left_joins(:likes)
                       .group(:id)
                       .select('posts.*, COUNT(likes.id) AS likes_count')
                       .order('likes_count DESC')
        elsif params[:sort_by] == 'comments'
          @posts = Post.left_joins(:comments)
                       .group(:id)
                       .select('posts.*, COUNT(comments.id) AS comments_count')
                       .order('comments_count DESC')
        else
          @posts = Post.all.order('created_at DESC')
        end

        render json: @posts
      end

      def show
        render json: @post
      end

      def create
        @post = @current_user.posts.build(post_params)
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
        @post.likes.where(user: @current_user).first_or_create
        render json: { count: @post.likes.count }, status: :ok
      end

      def unlike
        @post.likes.where(user_id: @current_user.id).destroy_all
        render json: { count: @post.likes.count }, status: :ok
      end

      # Query fetched from the google
      def top_posts
        top_posts = Post.joins(:likes, :comments)
                       .select('posts.*, COUNT(DISTINCT likes.id) AS total_likes, COUNT(DISTINCT comments.id) AS total_comments')
                       .group('posts.id')
                       .order('total_likes DESC, total_comments DESC')
                       .limit(10)

        render json: top_posts, status: :ok
      end

      def recommended_posts
        user_following_ids = @current_user.followed_users.pluck(:id)

        # Query fetched from the google
        recommended_posts = Post.joins(:likes)
                                .where(likes: { user_id: user_following_ids })
                                .select('posts.*, COUNT(DISTINCT likes.id) AS total_likes')
                                .group('posts.id')
                                .order('total_likes DESC')
                                .limit(10)

        render json: recommended_posts, status: :ok
      end

      def more_posts_by_similar_author
        similar_author_id = @post.author_id

        # Fetch more posts by authors similar to the current post's author
        more_posts = Post.where(author_id: similar_author_id).where.not(id: @post.id).limit(10)

        render json: more_posts, status: :ok
      end

      def save_for_later
        if @current_user.saved_for_later.include?(@post)
          @current_user.saved_for_later << @post
        end
        render json: { count: @current_user.saved_for_later.count }, status: :ok
      end

      def unsave
        @current_user.saved_for_later.delete(@post)
        render json: { count: @current_user.saved_for_later.count }, status: :ok
      end

      def search
        query = params[:query]
        if query.present?
          posts = Post.where('title ILIKE ? OR content ILIKE ?', "%#{query}%", "%#{query}%")
          render json: posts
        else
          render json: { error: 'Search query parameter "query" is required.' }, status: :bad_request
        end
      end

      def stats
        data = { likes_count: @post.likes.count, coments_count: @post.comments.count }
        render json: data, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.permit(:title, :content, :status)
      end
    end
  end
end
