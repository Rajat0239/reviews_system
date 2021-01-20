class Api::GoalController < ApplicationController
  skip_load_and_authorize_resource
  
  def create
    role = User.find(params[:user_id]).current_role
    role_id =Role.find_by(name: role).id
    question_count = Question.where(role_id: role_id).count
    over_all_rating = Review.over_all_ratings_of_user(params[:user_id])
    over_all_percentage = over_all_rating*1.0/question_count
    render json: over_all_percentage
  end
  
end
