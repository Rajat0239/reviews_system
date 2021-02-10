class Api::QuestionsController < ApplicationController

  before_action :role_is_admin, only: [:create, :update]

  def index
    if role_is_admin
      render json: Role.joins("INNER JOIN questions ON roles.id = questions.role_id INNER JOIN question_types on questions.question_type_id = question_types.id").select("questions.id, roles.name, questions.question, question_types.q_type, questions.options") 
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
