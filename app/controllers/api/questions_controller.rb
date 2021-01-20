class Api::QuestionsController < ApplicationController

  before_action :role_is_admin

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
