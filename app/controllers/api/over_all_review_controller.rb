class Api::OverAllReviewController < ApplicationController
  skip_load_and_authorize_resource
  
  def index
    over_all_rating = Review.over_all_ratings_of_user(params[:user_id])
    over_all_percentage = (over_all_rating/20.0)*100
    render json: over_all_percentage
  end
  
end
