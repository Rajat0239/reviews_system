class Api::ReviewsController < ApplicationController
  def index
    (current_user.roles.pluck(:name).include? "manager") || (current_user.roles.pluck(:name).include? "admin") ? (render json: Review.all) : (render json: current_user.reviews)
  end
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.save ? (render json: @review) : (@review.errors.full_messages)
  end
  def update
    if current_user.roles.pluck(:name).include? "manager"
      @review.status = true
      @review.update(review_params)
      render json: @review
    elsif !@review.status && @review.user_id == current_user.id
      @review.update(review_params)
      render json: @review
    else
      render json: "You can not update"
    end
  end
  private
    def review_params
      params.permit(:ratings , :feedback)
    end
end
