# app/controllers/api/v1/comments_controller.rb
module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post

      def index
        @comments = @post.comments
        render json: @comments
      end

      def show
        @comment = @post.comments.find(params[:id])
        render json: @comment
      end

      def create
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def update
        @comment = @post.comments.find(params[:id])
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment = @post.comments.find(params[:id])
        @comment.destroy
        head :no_content
      end

      def like
        @comment.likes.create(user: current_user)
        render json: @comment, status: :ok
      end

      def unlike
        @comment.likes.where(user_id: current_user.id).destroy_all
        render json: @comment, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
