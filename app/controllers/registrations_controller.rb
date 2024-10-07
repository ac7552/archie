require 'byebug'
class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end