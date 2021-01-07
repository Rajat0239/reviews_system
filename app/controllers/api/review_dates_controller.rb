class Api::ReviewDatesController < ApplicationController
  def create
    if !(ReviewDate.find_by(quarter: current_quarter))
      @review = current_user.review_dates.new(review_date: params[:review_date], review_deadline_date: (params[:review_date].to_date + 7.days), quarter: current_quarter)
      (@review.save) ? (UserMailer.review_date_email(@review).deliver_now; render json: "Date Given") : (render json: "Not created")
    else
      render json: "can update"
    end 
  end
end