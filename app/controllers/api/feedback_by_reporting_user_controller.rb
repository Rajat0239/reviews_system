class Api::FeedbackByReportingUserController < ApplicationController

  before_action :check_review_of_user, only: [:create]

  def index
    if role_is_admin
      feedback_listFor_admin = []
      @feedbacks = FeedbackByReportingUser.includes(:user).where(quarter:current_quarter)
      @feedbacks.each { |feedback|
        feedback_listFor_admin << feedback.attributes.merge(user: feedback.user, feedback_for_this_user: User.find(feedback.feedback_for_user_id))
      }
      (feedback_listFor_admin.empty?) ? (render :json => {:message => "Sorry! Feedback Not Available"}) : (render json: feedback_listFor_admin)
    elsif current_user.current_role == "manager"
      
      feedback_listFor_manager = []
      feedbacks_by_manager = current_user.feedback_by_reporting_users.includes(:user).where(quarter:current_quarter)
      feedbacks_by_manager.each { |feedback|
        feedback_listFor_manager << feedback.attributes.merge(user: feedback.user, feedback_for_this_user: User.find(feedback.feedback_for_user_id))
      }
      (feedback_listFor_manager.empty?) ? (render :json => {:message => "Sorry! Feedback Not Available"}) : (render json: feedback_listFor_manager)
    else
      employee_feedback = FeedbackByReportingUser.where(feedback_for_user_id:current_user.id, quarter:current_quarter, status:"true")
      (employee_feedback.empty?) ? (render :json => {:message => "Sorry! Feedback Not Available"}) : (render json: employee_feedback)
    end
  end

  def create
    @user = User.find(params[:feedback_for_user_id])
    if @user.reporting_user_id == current_user.id
      @feedback = current_user.feedback_by_reporting_users.new(date_params)
      @feedback.quarter = current_quarter
      (@feedback.save) ? (render :json => {:message => "Feedback Create Successfully"}; UserMailer.reprting_feedback_email(@feedback).deliver_now) : (render json:  @feedback.errors[:feedback_for_user_id])     
    else 
      render json: "Sorry! You Can't give feedback for this User"
    end
  end

  def update
    if @feedback_by_reporting_user.update(status: params[:status])
      UserMailer.employee_feedback_acknowledgement_mail(@feedback_by_reporting_user).deliver_now
      render :json => {:message=> "Feedback Status Update Successfully!"}
    else
      render json: "can't update this feedback" 
    end
  end

  private

    def date_params
      params.permit(:feedback, :feedback_for_user_id, :status)
    end

    def check_review_of_user
      @review = Review.where(user_id: params[:feedback_for_user_id], quarter:current_quarter)
      render json: "Sorry! You Con't give feedback for this User Becouse this use review not available " if @review.empty?
    end
    
end