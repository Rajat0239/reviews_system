class Api::QuestionsController < ApplicationController

  before_action :role_is_admin, only: [:create, :update]

  def index
    if role_is_admin
      render json: Question.all 
    else
      @role_id = Role.find_by(name: current_user.current_role).id
      @questions = Question.where(role_id: @role_id)
      render json: @questions
    end
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
      params.permit(:question, :role_id, :question_type_id, :options)
    end
  
end
