class Api::QuestionsController < ApplicationController

  before_action :role_is_admin, only: [:create, :update]

  def index
    Question.all if role_is_admin
    @questions = Question.where(role_id: params[:role_id])
    render json: @questions
  end

  def create
    @question = Question.new(question_params)
    @question.save ? (render json: @question.as_json) : (render json: @question.errors.messages)
  end

  def update
    @question.update(question_params) ? (render json: @question) : (render json: @question)
  end

  private

    def question_params
      params.permit(:question, :role_id) 
    end
  
end
