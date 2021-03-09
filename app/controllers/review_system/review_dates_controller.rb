class ReviewSystem::ReviewDatesController < ApplicationController

  def index
    @review_dates = ReviewDate.date_for_quarter(current_quarter)
    if @review_dates.present?
      render json: @review_dates.as_json(only: [:start_date, :deadline_date, :id])
    else
      render json: "date is not available"
    end
  end

  def create
    @review_date = ReviewDate.new(date_params)
    (@review_date.save) ? (render :json => {:message => "date is generated for the quarter"}) : (render json:  @review_date.errors[:base])
  end

  def update
    @review_date.update(date_params) ? (render :json => {:message => "#{custom_message_if_start_date_is_passed}date is updated from #{@review_date.start_date} to #{@review_date.deadline_date}"}) : (render json: @review_date.errors[:base])
  end

  private

    def date_params
      params.require(:review_dates).permit(:start_date, :deadline_date)
    end
    
    def custom_message_if_start_date_is_passed
      return "start date can not be update and " if @review_date.start_date < Date.today
    end
    
end