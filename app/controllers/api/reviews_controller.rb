class Api::ReviewsController < ApplicationController
  
  def index
    if role_is_admin
      render json: Review.current_quarter_reviews(current_quarter).as_json
    else
      render json: current_user.reviews.user_current_quarter_reviews(current_quarter).as_json
    end
  end

  def create
    @review = current_user.reviews.new(review_params)
    @review.save ? (render json: @review) : (render json: @review.errors)
  end

  def update
    if current_user.id == @review.user.reporting_user_id
      @review.update(status: params[:status])
      send_not_approved_email
      render :json => {:message=> "review is updated"}
    elsif !@review.status && @review.user_id == current_user.id
      @review.update(review_params) ? (render json: @review.as_json) : (render json: @review.errors)  
    else
      render json: "can't update this review"
    end
  end

  private
  
    def review_params
      params.require(:review).permit(:ratings, :feedback, :question_id)
    end

    def send_not_approved_email
      UserMailer.not_approved_email(@review.user_id).deliver_now if params[:status] == "false"
    end
    
end