class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :recipe_not_processable
before_action :authorized

  def index
    render json: Recipe.all, status: :created
  end

  def create   
     user= User.find_by(id:session[:user_id])
    recipe= user.recipes.create!(params.permit(:title, :instructions, :minutes_to_complete))

    render json: recipe, status: :created
  end
  private
  # def recipe_params
  #   params.permit(:user_id, :title, :instructions, :minutes_to_complete)
  # end


  def recipe_not_processable(invalid)
     render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def authorized
return render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
  end
end
