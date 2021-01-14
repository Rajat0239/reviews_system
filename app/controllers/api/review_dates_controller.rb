class Api::ReviewDatesController < ApplicationController

  def index
    @review_dates = ReviewDate.date_for_quarter(current_quarter)
    render json: @review_dates.as_json(only: [:start_date, :deadline_date])
  end

  def create
    @review_date = ReviewDate.new(start_date: params[:start_date], deadline_date: params[:deadline_date], quarter: current_quarter)
    (@review_date.save) ? (render json: "date is generated for the quarter") : (render json:  @review_date.errors[:base])
  end

  def update
    @review_date.update(deadline_date: params[:deadline_date]) ? (render json: "deadline is updated to #{params[:deadline_date]}") : (render json: @review_date.errors[:base])
  end

end