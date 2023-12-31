module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user
      before_action :set_profile

      def show
        render json: { profile: @profile, img: url_for(@profile.avatar) }
      end

      def update
        if @profile.update(profile_params)
          render json: { profile: @profile, img: url_for(@profile.avatar) }
        else
          render json: @profile.errors, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.permit(:first_name, :last_name, :age, :gender, :avatar, :address)
      end

      def set_profile
        @profile = @current_user.profile
      end
    end
  end
end
