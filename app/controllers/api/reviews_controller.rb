class Api::ReviewsController < ApplicationController
  
  def index
    (current_user.current_role == "admin") ? (
      render json: Review.current_quarter_reviews(current_quarter)
      ) : (render json: current_user.reviews.user_current_quarter_reviews(current_quarter))
  end

  def create
    if in_a_valid_date
      (!can_give_review) ? (
        @review = current_user.reviews.new(review_params);
        (@review.save ? (render json: @review) : (render json: @review.errors.full_messages));
        ) : (render json: "you already submitted the review go to update")  
    else
      render json: "review date is expired or not available"
    end
  end

  def update
    in_a_valid_date ? (
      if current_user.id == @review.user.reporting_user_id
        params[:status] == "true" ? (@review.update(status: true); render json: @review) : (@review.update(status: false); UserMailer.not_approved_email(@review).deliver_now; render json: "updation link sent to the user";)
      elsif !@review.status && @review.user_id == current_user.id
        (@review.update(params.require(:review).permit(:ratings, :feedback)) ? (render json: @review) : (render json: @review.errors.full_messages))   
      else
        render json: "can't update this review"
      end
    ) : (render json: "review date is expired or not available")
  end

  private
    def review_params
      params.require(:review).permit(:ratings, :feedback, quarter: current_quarter, user_current_role: current_user.current_role)
    end

    def can_give_review
      return current_user.reviews.exists?(quarter: current_quarter)
    end

    def in_a_valid_date
      is_quarter_present ? ( 
        @review_date = ReviewDate.find_date(current_quarter);
        ((@review_date.start_date .. @review_date.deadline_date).cover?(Time.now.to_date) ? (return true) : (return false))
      ) : (return false)
    end
end