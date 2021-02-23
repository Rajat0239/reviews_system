class Api::FeedbackByReportingUsersController < ApplicationController
  before_action :check_review_of_user, only: [:create]

  def show
    @feedback_list = []
    status = "true"
    if role_is_admin
      @feedback = FeedbackByReportingUser.where(feedback_for_user_id:params[:feedback_for_user_id],quarter:current_quarter)
      @ratings = Rating.where(user_id:params[:feedback_for_user_id],quarter:current_quarter)
     elsif role_is_manager
      @feedback = current_user.feedback_by_reporting_users.where(feedback_for_user_id:params[:feedback_for_user_id],quarter:current_quarter)
      @ratings = Rating.where(user_id:params[:feedback_for_user_id],quarter:current_quarter,status:status)
    else
      @feedback = FeedbackByReportingUser.where(feedback_for_user_id:current_user.id, quarter:current_quarter)
      @ratings = Rating.where(user_id:params[:feedback_for_user_id],quarter:current_quarter,status:status)
    end
    @feedback_list = {"ratings" => @ratings,"feedbacks" => @feedback}
    if @feedback.empty?
      render :json => {:message => "Sorry! feedback is not available"}
    else
    (@ratings.empty?) ? (render :json => {:message => "Sorry! feedback is not approval by admin"}) : (render json: @feedback_list.as_json)
    end    
  end

  def create
    @error = create_feedbacks(params[:feedback_by_reporting_users], params[:rating_by_reporting_user_and_Userid])
    unless @error.present?
      UserMailer.reprting_feedback_email(@feedback).deliver_now
      render json: {message: "Feedback created successfully"}
    else
       render json: @error
    end
  end

  def update
    feedback_by_admin = params[:feedback_by_admin].as_json
    @feedback_by_reporting_user = Rating.where(user_id: params[:user_id])
    @feedback_by_reporting_user.update(feedback_by_admin) ? ( render :json => {:message=> "Feedback status update successfully!"}; UserMailer.employee_feedback_acknowledgement_mail(params[:user_id]).deliver_now) : (render json: "can't update this feedback")
  end

  private
  
  def create_feedbacks(feedback_of_data, rating_and_userid)
    error = ""
    if role_is_manager
      ActiveRecord::Base.transaction do
        @rating_by_reporting_user = Rating.where(user_id: rating_and_userid[:feedback_for_user_id], quarter: current_quarter)
        if @rating_by_reporting_user.update(ratings_by_reporting_user: rating_and_userid[:ratings_by_reporting_user])
           @user = User.find(rating_and_userid[:feedback_for_user_id])
          if @user.reporting_user_id == current_user.id
            feedback_of_data.map do |data|
              @feedback = current_user.feedback_by_reporting_users.new(data.as_json)
              @feedback.quarter = current_quarter
              @feedback.feedback_for_user_id = rating_and_userid[:feedback_for_user_id]
              unless @feedback.save
                error = @feedback.errors.full_messages
                raise ActiveRecord::Rollback
              end
            end
          else
            error = "Sorry! you can't give feedback this user"
          end      
        else  
          error = @rating_by_reporting_user.errors.full_messages
          raise ActiveRecord::Rollback
        end  
      end
    end  
    error
  end
   
    # def date_params
    #   params.require(:feedback_by_admin).permit(:rating_by_admin, :feedback_by_admin, :status)
    #   params.require(:feedback_by_reporting_users).permit(:feedback)
    #   params.require(:rating_by_reporting_user_and_Userid).permit(:ratings_by_reporting_user, :feedback_for_user_id)
    # end

    def check_review_of_user
      feedback_review_id = params[:feedback_by_reporting_users]
      feedback_review_id.map do |data|
        @review = Review.where(id: data[:review_id], quarter:current_quarter)
        if @review.empty?  
          render json: {message: "Sorry! You con't give feedback for this user becouse this user review not available "}
          break   
        end
      end
    end
end