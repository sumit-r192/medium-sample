module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user
      before_action :set_profile

      def show; end

      def update
        if @current_user.update(profile_params)
          render_resource(@current_user)
        else
          render json: @current_user.errors, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:user).permit(:name, :email, :avatar, :bio) # Add other profile fields as needed
      end

      def set_profile
        @profile = @current_user.profile
      end
    end
  end
end
