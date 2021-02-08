class Api::FeedbackByReportingUserController < ApplicationController

  def index
    if role_is_admin
      @feedbacks =  FeedbackByReportingUser.all
      (@feedbacks.empty?) ? (render :json => {:message => "Sorry! Feedback Not Available"}) : (render json: @feedbacks)
    else
      @feedbacks_byreportinguser = current_user.feedback_by_reporting_users
      (@feedbacks_byreportinguser.empty?) ? (render :json => {:message => "Sorry! Feedback Not Available"}) : (render json: @feedbacks_byreportinguser)
    end
  end

  def create
    @user = User.find(params[:feedback_for_user_id])
    if @user.reporting_user_id == current_user.id
      @feedback = current_user.feedback_by_reporting_users.new(date_params)
      (@feedback.save) ? (render :json => {:message => "Feedback Create Successfully"}; UserMailer.reprting_feedback_email(@feedback).deliver_now) : (render json:  @feedback.errors[:feedback_for_user_id])     
    else 
      render json: "Sorry! You Can't give feedback for this User"
    end
  end

  def update
    @feedback_data = current_user.feedback_by_reporting_users.find(params[:id]) 
    if @feedback_data.update(status: params[:status])
      UserMailer.employee_feedback_acknowledgement_mail(@feedback_data).deliver_now
      render :json => {:message=> "Feedback Status Update Successfully!"}
    else
      render json: "can't update this feedback" 
    end
  end

  private
    def date_params
      params.permit(:feedback, :quarter, :feedback_for_user_id, :status)
    end
    
end