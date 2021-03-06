module ReviewHelper
  def get_review
    @allotted_ids.map do |data|
    @allotted_question = QuestionForUser.find_by(id:data.question_for_user_id)
      @question = Question.find_by(id:@allotted_question.question_id) if @allotted_question.present?
      @review = Review.find_by(id:data.id)
      review = {review:  @question.attributes.merge( :review_id => @review.id, :answer => @review.answer )}  
      @reviews.push(review)
    end  
  end 
    
  def create_reviews(array_of_data, ratings)
    error = ""
    ActiveRecord::Base.transaction do
      @ratings =  current_user.ratings.new(quarter: current_quarter, ratings_by_user: ratings, reporting_user_id: current_user.reporting_user_id)
      unless @ratings.save  
        error = @ratings.errors.full_messages
        raise ActiveRecord::Rollback
      end
      array_of_data.map do |data|
        question = QuestionForUser.where(id: data[:question_for_user_id], status:"true", role_id: role_id)
        if question.empty?
          error = {:message => "Sorry! question is not available"}
          raise ActiveRecord::Rollback
        else
          @new_review = current_user.reviews.new(data.as_json)
          @new_review.quarter = current_quarter
          @new_review.user_current_role = current_user.id
          unless @new_review.save
            error = @new_review.errors.full_messages - ["User has already been taken"]
            raise ActiveRecord::Rollback
          end 
        end       
      end
    end 
    error    
  end

  def all_question_mendatory
    render json: {message: "all the questions are mendatory"} unless params[:reviews].count == QuestionForUser.where(role_id: role_id, status: true).count 
  end

  def send_email_to_reporting_user
    UserMailer.send_email_to_reporting_user(current_user).deliver
  end
end

