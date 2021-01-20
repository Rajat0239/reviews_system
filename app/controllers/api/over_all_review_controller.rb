class Api::OverAllReviewController < ApplicationController
  skip_load_and_authorize_resource
  
  def index
    byebug
    role = (User.find(params[:user_id]).current_role
    role_id =Role.find_by(name: @user).id
    # question_count = QuestionsForUser.where(role_id: role_id).count
    # over_all_rating = Review.over_all_ratings_of_user(params[:user_id])
    # over_all_percentage = (over_all_rating/question_count*5.0)*100
    # render json: over_all_percentage
  end
  
end
