class Api::ReviewsController < ApplicationController
  def index
    (roles.include? "admin") ? (render json: Review.select(:id, :ratings, :feedback).where(status:true)) : (render json: current_user.reviews)
  end
  def create
    if !review_status
      @review = current_user.reviews.new(review_params)
      @review.quarter = current_quarter
      @review.user_current_role = current_user.current_role
      @review.reporting_user_current_role = User.find_by(id: params[:review][:reporting_user_id].to_i)&.current_role
      @review.save ? (render json: @review) : (render json: @review.errors.full_messages)
    else
      render json: "You have given review for this quarter"
    end
  end
  def update
    if current_user.id == Review.find(params[:id]).reporting_user_id
      params[:status] == "true" ? (@review.update(status: true); render json: @review) : (@review.update(status: false); render json: "Updation message sent to the user"; UserMailer.sample_email(@review).deliver_now)
    elsif !@review.status && @review.user_id == current_user.id
      (@review.update(review_params) ? (render json: @review) : (render json: @review.errors.full_messages)) if @review.reporting_user_current_role = User.find(params[:review][:reporting_user_id]).current_role   
    else
      render json: "You can not update"
    end
  end
  def review_dates
    
  end
  private
    def review_params
      params.require(:review).permit(:ratings , :feedback, :reporting_user_id)
    end
end