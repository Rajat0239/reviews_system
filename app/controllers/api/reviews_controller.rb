class Api::ReviewsController < ApplicationController
  def index
    render json: Review.all
    @review = Review.where()
  end
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    byebug
    #@review.save ? (render json: @review) : (@review.errors.full_messages)
  end
  private
  def review_params
    params.permit(:ratings , :feedback)
  end
end
