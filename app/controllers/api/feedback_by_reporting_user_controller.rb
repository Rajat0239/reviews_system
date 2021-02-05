class Api::FeedbackByReportingUserController < ApplicationController

  def index
    @feedbacks_byreportinguser = current_user.feedback_by_reporting_users
    render json: @feedbacks_byreportinguser
  end

  def create
    @user = User.find(params[:feedback_for_user_id])
    if @user.reporting_user_id == current_user.id
      @feedback = current_user.feedback_by_reporting_users.new(date_params)
      (@feedback.save) ? (render :json => {:message => "Feedback Create Successfully"}) : (render json:  @feedback.errors[:feedback_for_user_id])
    else 
    render json: "Sorry! You Con't give feedback for this User"
    end
  end

  # def update
  #   @review_date.update(date_params) ? (render :json => {:message => "date is updated from #{@review_date.start_date} to #{@review_date.deadline_date}"}) : (render json: @review_date.errors[:base])
  # end

  private
    def date_params
      params.permit(:feedback, :quarter, :feedback_for_user_id)
    end
    
end