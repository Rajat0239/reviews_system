module ReviewFeedbackHelper

  def get_feedbacks(id,user_id)
    if role_is_admin
      user = User.find(user_id)
      @feedback = "Because this user has already a manager, so manager feedbacks are not available for this user! " if user.current_role == "manager"
      @feedback = FeedbackByReportingUser.find_by(review_id:id,quarter:current_quarter) if user.current_role != "manager"
    elsif role_is_manager
      @feedback = current_user.feedback_by_reporting_users.find_by(review_id:id,quarter:current_quarter)
    else
      @feedback = FeedbackByReportingUser.find_by(review_id:id,quarter:current_quarter)
    end 
  end
  
  def get_ratings(user_id)
    if role_is_admin
      @ratings = Rating.find_by(user_id:user_id,quarter:current_quarter)
    else
      @ratings = Rating.find_by(user_id:user_id,quarter:current_quarter,status:"true")
    end
  end

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
                error = @feedback.errors.full_messages.first
                raise ActiveRecord::Rollback
              end
            end
          else
            error = {message: "Sorry! you can't give feedback this user"}
          end      
        else  
          error = @rating_by_reporting_user.errors.messages
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
        render json: {message: "Sorry! You can't give feedback for this user becouse this user review not available "}
        break   
      end
    end
  end
end