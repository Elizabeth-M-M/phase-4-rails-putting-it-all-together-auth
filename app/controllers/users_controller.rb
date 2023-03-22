class UsersController < ApplicationController
# rescue_from ActiveRecord::RecordInvalid, with: :user_not_processable
#signup
  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id]= user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
#stay logged in
  def show
    user = User.find_by(id:session[:user_id])
    if user
      render json: user, status: :created
    else
      render json: {errors: "Not Authorized"}, status: :unauthorized

    end

  end
  private
  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  # def user_not_processable(invalid)
  #    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  # end
end
