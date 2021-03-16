class ReviewSystem::ReviewsController < ApplicationController
  include ReviewHelper
  before_action :all_question_mendatory, only: [:create]
  
  def show_reviews
    @reviews = []
    @allotted_ids = Review.find_question_for_user_id(params[:user_id], current_quarter)
    if !@allotted_ids.empty?
      get_review
      @ratings = Rating.find_by(user_id: params[:user_id], quarter: current_quarter).ratings_by_user
      render json: @reviews.push("ratings": @ratings, "user_id": params[:user_id])
    else
      render :json => {:message => "review is not available for this user"}
    end
  end

  def create
    @error = create_reviews(params[:reviews],params[:ratings])
    if @error.present?
      render json: @error
    else
      send_email_to_reporting_user
      render json: {message: 'given successfully'} 
    end
  end

end
