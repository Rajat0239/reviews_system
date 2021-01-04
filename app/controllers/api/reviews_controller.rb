class Api::ReviewsController < ApplicationController
  def index
    if roles.include? "admin"
      render json: Review.select(:id, :ratings,:feedback).where(status: true)
    elsif roles.include? "manager"
      #render json: Review.where(reporting_user_id: current_user.id || user_id: current_user.id)
    else
      
    end
  end
  def create
    !review_status ? (@review = current_user.reviews.new(review_params); @review.quarter = current_quarter; @review.save ? (render json: @review) : (@review.errors.full_messages)) : (render json: "You have given review for this quarter")
  end
  def update
      if current_user.id == Review.find(params[:id]).reporting_user_id
        params[:status] == "true" ? (@review.update(status: true); render json: @review) : (@review.update(status: false); render json: "Not approved send a message to a user")
      elsif !@review.status && @review.user_id == current_user.id
        @review.update(review_params) ? (render json: @review) : (render json: @review.errors.full_messages)
      else
        render json: "You can not update"
      end
  end
  private
    def review_params
      params.permit(:ratings , :feedback, :reporting_user_id)
    end
end
