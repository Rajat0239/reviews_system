class Api::ReviewsController < ApplicationController
  def index
    render json: User.reviews
  end
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.save ? (render json: @review) : (@review.errors.full_messages)
  end
  def update
    @review = current_user.reviews.where(id: params[:id])
    @review.update(review_params)
  end
  private
    def review_params
      params.permit(:ratings , :feedback)
    end
end
