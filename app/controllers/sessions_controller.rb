class SessionsController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :user_not_processable

before_action :authorized
skip_before_action :authorized, only: [:create]

  #login
  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: ["Invalid username or password"] }, status: :unauthorized
    end

  end

  def destroy
    
    session.delete :user_id
    head :no_content
  end

  private
  def user_not_processable(invalid)
     render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end
  def authorized
    return render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
  end

end
