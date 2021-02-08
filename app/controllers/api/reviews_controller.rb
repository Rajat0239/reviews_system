class Api::ReviewsController < ApplicationController
  
  before_action :all_question_mendatory

  def index
    current_user_current_quarter_reviews = Question.joins(:reviews).where("reviews.question_id = questions.id AND reviews.user_id = ? AND reviews.quarter = ?",current_user.id,current_quarter).select("questions.id, reviews.answer, questions.question")
    render json: current_user_current_quarter_reviews
  end

  def create
    @review_create_status = true
    create_reviews(params[:reviews].values)
    render json: "submitted successfully" if @review_create_status == true
  end

  private
    
    def create_reviews(array_of_data)
      current_user.reviews.transaction do
        array_of_data.map do |data|
          new_review = current_user.reviews.new(data)
          unless new_review.save
            error = new_review.errors.full_messages - ["User has already been taken"]
            render json: error
            @review_create_status = false
            raise ActiveRecord::Rollback
          end
        end
      end     
    end

    def all_question_mendatory
      render json: "all the questions are mendatory" unless params[:reviews].values.count == Role.find_by(name: current_user.current_role).questions.count
    end

end