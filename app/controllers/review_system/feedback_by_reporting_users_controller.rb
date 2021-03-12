class ReviewSystem::FeedbackByReportingUsersController < ApplicationController
  include ReviewFeedbackHelper
  before_action :check_review_of_user, only: [:create]

  def show
    @reviews = []
    allotted_ids = Review.where(user_id: params[:feedback_for_user_id], quarter: current_quarter)
    allotted_ids.map do |data|
      @question = QuestionForUser.where(id: data.question_for_user_id).joins(:question)
      @question = @question.first.question unless @question.empty?
      get_feedbacks(data.id, params[:feedback_for_user_id])
        if !@feedback.present? || !@question.present?
          render json: { message: 'Sorry! feedback is not available!' }
          return
        else
          @review = Review.find_by(id: data.id)
          review = { review: @question.attributes.merge(review_id: @review.id, answer: @review.answer,reporting_user_feedback: @feedback.feedback) }
          @reviews.push(review)
        end
    end
    get_ratings(params[:feedback_for_user_id])
      if !@ratings.present?
        render json: { message: 'Sorry! feedback is not approval by admin!' }
      else
        @ratings = { 'ratings' => @ratings }
        @reviews.empty? ? (render json: { message: 'Sorry! review is not available!' }) : (render json: @reviews.push(@ratings))
      end
  end

  def create
    @error = create_feedbacks(params[:feedback_by_reporting_users], params[:rating_by_reporting_user_and_Userid])
    if @error.present?
      render json: { message: @error }
    else
      UserMailer.reprting_feedback_email(@feedback).deliver_now
      render json: { message: 'Feedback created successfully' }
    end
  end

  def update
    feedback_by_admin = params[:feedback_by_admin].as_json
    @feedback_by_reporting_user = Rating.where(user_id: params[:user_id])
    if @feedback_by_reporting_user.update(feedback_by_admin)
      (render json: { message: 'Feedback status update successfully!' }
       UserMailer.employee_feedback_acknowledgement_mail(params[:user_id]).deliver_now)
    else
      (render json: "can't update this feedback")
    end
  end
end

