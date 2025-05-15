class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [ :create, :show ]

  def create
    user = User.new(user_params.except(:avatar))

    if user.save
      user.avatar.attach(params[:avatar]) if params[:avatar].present?

      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: user
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def me
    render json: @current_user
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation, :bio, :avatar)
  end
end
