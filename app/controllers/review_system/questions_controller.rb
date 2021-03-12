class ReviewSystem::QuestionsController < ApplicationController
  include QuestionHelper
  def index
    @questions = Question.all
    @role_id = params[:role_id]
  end

  def question_list
    role_id = params['role']
    get_question(role_id)
    @question.empty? ? (render json: { message: 'Sorry! question is not available !' }) : (render json: @question.as_json)
  end

  def create
    @question = Question.new(question_params)
    @question.save ? (render json: { message: 'question created successfully' }) : (render json: @question.errors)
  end

  def show
    @question
  end

  def update
    @status = @question.status ? false : true
    @question.update(status: @status) ? (render json: { message: 'question has been Deleted' }) : (render json: @question.errors.messages)
  end

  private

  def question_params
    params.require(:question_list).permit(:question, :question_type_id, :options)
  end
end
