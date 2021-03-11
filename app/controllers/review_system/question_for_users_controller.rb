class ReviewSystem::QuestionForUsersController < ApplicationController
  before_action :role_is_admin, only: %i[create update destroy]
  include QuestionForUserHelper

  def index
    @questions = QuestionForUser.where(role_id: role_id, status: true).joins(:question)
    if @questions.empty?
      render json: { message: 'Sorry! question is not available for this role' }
    else
      alloted_question 
      alloted_question.empty? ? (render json: { message: 'Sorry! question is not available for this role' }) : (render json: alloted_question)
    end
  end

  def create
    @error = add_question(params[:question_for_users])
    if @error.present?
      render json: { message: @error}
    else
      render json: { message: 'Question add successfully for this role!' }
    end
  end

  def update
    @question = QuestionForUser.find(params[:id])
    @question.update(status: !@question.status) ? (render json: { message: 'Question status update successfully' }) : (render json: @question.errors)
  end

  def destroy
    @question_for_user
    @question_for_user.destroy ? (render json: { message: 'Question Delete successfully for this role!' }) : (render json: @question_for_user.errors)
  end

end


