# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end
end
