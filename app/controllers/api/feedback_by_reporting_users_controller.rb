class Api::FeedbackByReportingUsersController < ApplicationController
  before_action :check_review_of_user, only: [:create]
  def show
    if role_is_admin
      @feedback = FeedbackByReportingUser.where(feedback_for_user_id:params[:feedback_for_user_id],quarter:current_quarter)
    elsif role_is_manager
      @feedback = current_user.feedback_by_reporting_users.where(feedback_for_user_id:params[:feedback_for_user_id],quarter:current_quarter)
    else
      @feedback = FeedbackByReportingUser.where(feedback_for_user_id:current_user.id, quarter:current_quarter, status:"true")
    end
      (@feedback.empty?) ? (render :json => {:message => "Sorry! feedback is not available"}) : (render json: @feedback.as_json(only: [:id, :user_id, :feedback, :feedback_for_user_id]))
  end
  
  def create
    @error = create_feedbacks(params[:feedback_by_reporting_users])
    unless @error.present?
      UserMailer.reprting_feedback_email(@feedback).deliver_now
      render json: {message: "Feedback created successfully",}
    else
      render json: @error
    end
  end
  def update
    @feedback_by_reporting_user = FeedbackByReportingUser.where(feedback_for_user_id: params[:user_id])
    @feedback_by_reporting_user.update(quarter: current_quarter, status: params[:feedback_by_reporting_users][:status]) ? ( render :json => {:message=> "Feedback status update successfully!"}; UserMailer.employee_feedback_acknowledgement_mail(params[:user_id]).deliver_now) : (render json: "can't update this feedback")
  end
  private
  def create_feedbacks(array_of_data)
    error = ""
    ActiveRecord::Base.transaction do
      array_of_data.map do |data|
        @user = User.find(data[:feedback_for_user_id])
        if @user.reporting_user_id == current_user.id
          @feedback = current_user.feedback_by_reporting_users.new(data.as_json)
          @feedback.quarter = current_quarter
          unless @feedback.save
            error = @feedback.errors.full_messages
            raise ActiveRecord::Rollback
          end
        else
          error = "Sorry! you can't give feedback for this user"
        end
      end
    end
    error
  end
    def date_params
      params.require(:feedback_by_reporting_users).permit(:review_id, :feedback, :status)
    end
    def check_review_of_user
      @review = Review.where(id: params[:feedback_by_reporting_users][0][:review_id], quarter:current_quarter)
      render json: "Sorry! You con't give feedback for this user becouse this use review not available " if @review.empty?
    end
end