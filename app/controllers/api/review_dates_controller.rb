class Api::ReviewDatesController < ApplicationController

  def index
    @review_dates = ReviewDate.date_for_quarter(current_quarter)
    render json: @review_dates.as_json(only: [:start_date, :deadline_date])
  end

  def create
    if !is_quarter_present
      @review_date = ReviewDate.new(start_date: params[:date], deadline_date: (params[:date].to_date + 10.days), quarter: current_quarter)
      (@review_date.save) ? (render json: "date is generated for the quarter") : (render json: @review_date.errors)
    else
      render json: "date is already generated for the quarter go to update"
    end 
  end

  def update
    if is_quarter_present
      @review_date.update(deadline_date: params[:date]) ? (render json: "deadline is updated to #{params[:date]}") : (render json: @review_date.errors)
    else
      render json: "can't update the date"
    end
  end

end