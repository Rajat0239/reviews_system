class Api::FeedbackByReportingUserController < ApplicationController

  def index
    @feedbacks_byreportinguser = current_user.feedback_by_reporting_users
    render json: @feedbacks_byreportinguser
  end

  def create
    @feedback = current_user.feedback_by_reporting_users.new(date_params)
    (@feedback.save) ? (render :json => {:message => "Feedback Create Successfully"}) : (render json:  @feedback.errors[:feedback_for_user_id])
  end

  # def update
  #   @review_date.update(date_params) ? (render :json => {:message => "date is updated from #{@review_date.start_date} to #{@review_date.deadline_date}"}) : (render json: @review_date.errors[:base])
  # end

  private
    def date_params
      params.permit(:feedback, :quarter, :feedback_for_user_id)
    end
    
end