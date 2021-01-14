class Api::ReviewsController < ApplicationController
  
  def index
    if role_is_admin
      render json: Review.current_quarter_reviews(current_quarter)
    else
      render json: current_user.reviews.user_current_quarter_reviews(current_quarter)
    end
  end

  def create
    @review = current_user.reviews.new(review_params)
    @review.save ? (render json: @review) : (render json: @review.errors[:base])
  end

  def update
    if current_user.id == @review.user.reporting_user_id
      @review.update(status: params[:status])
    elsif !@review.status && @review.user_id == current_user.id
      @review.update(review_params) ? (render json: @review) : (render json: send_error_messages(@review))  
    else
      render json: "can't update this review"
    end
  end

  private
    def review_params
      params.require(:review).permit(:ratings, :feedback)
    end

end