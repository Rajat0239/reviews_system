class Api::ReviewsController < ApplicationController
  before_action :in_a_valid_date, only: [:create, :update]
  before_action :can_give_review, only: [:create]
  
  def index
    if role_is_admin
      render json: Review.current_quarter_reviews(current_quarter)
    else
      render json: current_user.reviews.user_current_quarter_reviews(current_quarter)
    end
  end

  def create
    @review = current_user.reviews.new(review_params)
    @review.quarter = current_quarter;
    @review.user_current_role = current_user.current_role;
    @review.save ? (render json: @review) : (render json: send_error_messages(@review))
  end

  def update
    if current_user.id == @review.user.reporting_user_id
      @review.update(status: params[:status])
      send_not_approved_email_to(@review.user_id) if params[:status] == "false"
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

    def can_give_review
      render json: "you already submitted the review go to update" if current_user.reviews.exists?(quarter: current_quarter)
    end

    def in_a_valid_date
      if is_quarter_present
        @review_date = ReviewDate.find_date(current_quarter);
        render json: "review date is expired or not available" unless (@review_date.start_date .. @review_date.deadline_date).cover?(Time.now.to_date)
      else
        render json: "review date is expired or not available"
      end
    end

    def send_not_approved_email_to(review)
      UserMailer.not_approved_email(review).deliver_now
    end
end