class Api::ReviewDatesController < ApplicationController

  def index
    
  end
  
  def create
    if !is_quarter_present
      @review_date = ReviewDate.new(start_date: params[:date], deadline_date: (params[:date].to_date + 7.days), quarter: current_quarter)
      (@review_date.save) ? (UserMailer.review_date_email(@review_date).deliver_now; render json: "date is generated for the quarter") : (render json: @review_date.errors)
    else
      render json: "date is already generated for the quarter go to update"
    end 
  end

  def update
    if is_quarter_present
      @review_date.update(deadline_date: params[:deadline_date])
      render json: "deadline is updated to #{params[:deadline_date]}"
    else
      render json: "can't update the date"
    end
  end
end