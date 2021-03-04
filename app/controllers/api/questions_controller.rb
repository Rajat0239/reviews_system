class Api::QuestionsController < ApplicationController

  before_action :role_is_admin, only: [:create, :update, :index]

  def index
    unless params[:role_id].present?
      @question = QuestionType.joins(:questions).where("questions.status = ?", true).select("questions.id, questions.question, questions.options,question_types.q_type")
      render json: @question
    else
      @role = Role.find(params[:role_id])
      @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,@role.id).select("question_for_users.id, question_for_users.question_id,questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
      render json: @question
    end
  end

  def create
    @question = Question.new(params.require(:question_list).permit(:question, :question_type_id, :options))

    @question.save ? (render json: {message: "question created successfully"}) : (render json: @question.errors)
  end

  def show
    render json: @question
  end

  def update
    @question_status = question.find(params[:id])
    (@question_status.status == "true") ? (status = "false") : (status = "true")
    @question_status.update(status: status) ? (render :json => {:message => "Question status update successfully"}) : (render json: @question_status.errors)
    # @question.update(question_params) ? (render :json => {:message => "question updated successfully"}) : (render json: @question.errors)
  end

  def destroy
    @question
    (@question.destroy) ? (render json: {:message => "Question Delete successfully !"}) : (render json: @question.errors)
  end

  private
  def question_params
    params.require(:question_list).permit(:question, :question_type_id, :options)
  end
  
end
