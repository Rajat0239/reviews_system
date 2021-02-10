class Api::FeedbackByReportingUsersController < ApplicationController

  before_action :check_review_of_user, only: [:create]
  
  def show
    if role_is_admin
      feedbacks = FeedbackByReportingUser.find_by(feedback_for_user_id:params[:feedback_for_user_id],quarter:current_quarter)
    elsif role_is_manager  
      feedbacks = current_user.feedback_by_reporting_users.find_by(feedback_for_user_id:params[:feedback_for_user_id],quarter:current_quarter)
    else
      feedbacks = FeedbackByReportingUser.find_by(feedback_for_user_id:current_user.id, quarter:current_quarter, status:"true")
    end
      (feedbacks.nil?) ? (render :json => {:message => "Sorry! feedback not available"}) : (render json: feedbacks) 
  end
  
  def create
    @user = User.find(params[:feedback_by_reporting_users][:feedback_for_user_id])
    if @user.reporting_user_id == current_user.id
       @feedback = current_user.feedback_by_reporting_users.new(date_params)
       @feedback.quarter = current_quarter
      (@feedback.save) ? (render :json => {:message => "Feedback create successfully"}; UserMailer.reprting_feedback_email(@feedback).deliver_now) : (render json:  @feedback.errors[:feedback_for_user_id])     
    else 
      render json: "Sorry! you can't give feedback for this user"
    end
  end

  def update
    @feedback_by_reporting_user.update(status: params[:feedback_by_reporting_users][:status]) ? ( render :json => {:message=> "Feedback status update successfully!"}; UserMailer.employee_feedback_acknowledgement_mail(@feedback_by_reporting_user).deliver_now) : (render json: "can't update this feedback")
  end

  private
  
    def date_params
      params.require(:feedback_by_reporting_users).permit(:feedback, :feedback_for_user_id, :status)
    end

    def check_review_of_user
      @review = Review.where(user_id: params[:feedback_by_reporting_users][:feedback_for_user_id], quarter:current_quarter)
      render json: "Sorry! You con't give feedback for this user becouse this use review not available " if @review.empty?
    end
    
end