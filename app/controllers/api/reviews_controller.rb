class Api::ReviewsController < ApplicationController
  
  before_action :all_question_mendatory, only: [:create]

  def index
    @current_user_current_quarter_reviews = Question.joins(:reviews).where("reviews.question_id = questions.id AND reviews.user_id = ? AND reviews.quarter = ?",current_user.id,current_quarter).select("questions.id, reviews.answer, questions.question")
    unless @current_user_current_quarter_reviews.empty?
      @ratings = current_user.ratings.find_by(quarter: "1 2021").ratings_by_user
      render json: @current_user_current_quarter_reviews.to_a.push({"ratings": @ratings})  
    else
      render json: {message: "you have not given the review"}
    end
  end

  def create
    @error = create_reviews(params[:reviews],params[:ratings])
    unless @error.present?
      send_email_to_reporting_user
      render json: {message: "Reviews & rating submitted successfully !", role: current_user.current_role} 
    else
      render json: @error
    end
  end

  private
    
    def create_reviews(array_of_data, ratings)
      error = ""
      ActiveRecord::Base.transaction do
        @ratings =  current_user.ratings.new(quarter: current_quarter, ratings_by_user: ratings, reporting_user_id: current_user.reporting_user_id)
        unless @ratings.save  
          error = @ratings.errors.full_messages
          raise ActiveRecord::Rollback
        end
        array_of_data.map do |data|
          @new_review = current_user.reviews.new(data.as_json)
          @new_review.quarter = current_quarter
          @new_review.user_current_role = current_user.id
          unless @new_review.save
            error = @new_review.errors.full_messages - ["User has already been taken"]
            raise ActiveRecord::Rollback
          end
        end
      end 
      error    
    end

    def all_question_mendatory
      render json: "all the questions are mendatory " unless params[:reviews].count == Role.find_by(name: current_user.current_role).questions.count
    end

    def send_email_to_reporting_user
      UserMailer.send_email_to_reporting_user(current_user).deliver
    end
end