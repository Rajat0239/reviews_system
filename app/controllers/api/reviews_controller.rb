class Api::ReviewsController < ApplicationController
  
  def index
    if role_is_admin
      render json: Review.current_quarter_reviews(current_quarter).as_json
    else
      current_user_current_quarter_reviews = Question.joins(:reviews).where("reviews.question_id = questions.id AND reviews.user_id = ? AND reviews.quarter = ?",current_user.id,current_quarter).select("questions.id, reviews.ratings, reviews.feedback, questions.question")
      render json: current_user_current_quarter_reviews
    end
  end

  def show
    @reviews = User.find(params[:id]).reviews.where(quarter: current_quarter)
    render json: @reviews
  end

  def create
    @count = 0
    create_reviews(params[:review].values)
    render json: "submitted successfully" if @count == 1
  end

  def update
    if current_user.id == @review.user.reporting_user_id
      @review.update(status: params[:status])
      send_not_approved_email
      render :json => {:message=> "review is updated"}
    elsif !@review.status && @review.user_id == current_user.id
      @review.update(review_params) ? (render json: @review.as_json) : (render json: @review.errors)  
    else
      render json: "can't update this review"
    end
  end

  private
  
    def review_params
      params.permit(review_attributes: [:ratings, :feedback, :question_id])
    end
  
    def send_not_approved_email
      UserMailer.not_approved_email(@review.user_id).deliver_now if params[:status] == "false"
    end
    
    def create_reviews(array_of_data)
      current_user.reviews.transaction do
        array_of_data.map do |data|
          new_review = current_user.reviews.new(data)
          unless new_review.save
            error = new_review.errors.full_messages - ["User has already been taken"]
            render json: error
            raise ActiveRecord::Rollback
          else
            @count = 1
          end
        end
      end     
    end

end