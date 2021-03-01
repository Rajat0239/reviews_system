class Api::FeedbackByReportingUsersController < ApplicationController
  before_action :check_review_of_user, only: [:create]

  def show
    @reviews = []
    allotted_ids = Review.where(user_id: params[:feedback_for_user_id],quarter:current_quarter).select("id, question_for_user_id")
    if !allotted_ids.empty?
      allotted_ids.map do |data|
      allotted_question = QuestionForUser.find_by(id:data.question_for_user_id)
      @question = Question.find_by(id:allotted_question.question_id) if allotted_question.present?
      @question = QuestionBackup.find_by(question_id:allotted_question.question_id) if !@question.present?
       
        if role_is_admin
          user = User.find(params[:feedback_for_user_id])
          @feedback = "Because this user has already a manager, so manager feedbacks are not available for this user! " if user.current_role == "manager"
          @feedback = FeedbackByReportingUser.find_by(review_id:data.id,quarter:current_quarter) if user.current_role != "manager"
          @ratings = Rating.find_by(user_id:params[:feedback_for_user_id],quarter:current_quarter)
        
        elsif role_is_manager
          @feedback = current_user.feedback_by_reporting_users.find_by(review_id:data.id,quarter:current_quarter)
          @ratings = Rating.find_by(user_id:params[:feedback_for_user_id],quarter:current_quarter,status:"true")
        
        else
          @feedback = FeedbackByReportingUser.find_by(review_id:data.id,quarter:current_quarter)
          @ratings = Rating.find_by(user_id:params[:feedback_for_user_id],quarter:current_quarter,status:"true")
        end
        
        if !@feedback.present?
          render :json => {:message => "Sorry! feedback is not available!"}
          return  
        elsif !@ratings.present?
          render :json => {:message => "Sorry! feedback is not approval by admin!"} 
          return
        end 
         
        @review = Review.find_by(id:data.id)
        review = {review:  @question.attributes.merge( :review_id => @review.id, :answer => @review.answer, :reporting_user_feedback =>@feedback.feedback )}  
        @reviews.push(review)
      end  
    end
    @ratings = {"ratings" => @ratings}
    (@reviews.empty?) ? (render :json => {:message => "Sorry! review is not available!"}) : (render json: @reviews.push(@ratings))
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
            error = {message: "Sorry! you can't give feedback this user"}
          end      
        else  
          error = @rating_by_reporting_user.errors.full_messages
          raise ActiveRecord::Rollback
        end  
      end
    end  
    error
  end

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