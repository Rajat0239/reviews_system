class ReviewSystem::QuestionsController < ApplicationController

  def index
    @questions = Question.all
    @role_id = params[:role_id]
  end

  def question_list
    role_id = params["role"]
    if role_id == "1"
      @question = QuestionType.joins(:questions).select("questions.id, questions.question, questions.options,question_types.q_type")
    else
      @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role_id).select("question_for_users.id, question_for_users.question_id,questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
    end
    (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role !"}) : (render json: @question.as_json)
  end

  def create
    @question = Question.new(question_params)
    @question.save ? (render json: {message: "question created successfully"}) : (render json: @question.errors)
  end

  def show
    @question
  end

  def update
    @status = @question.status ? false : true
    @question.update(status: @status) ? (render :json => {:message => "question has been updated"}) : (render json: @question.errors)
  end

  private

  def question_params
    params.require(:question_list).permit(:question, :question_type_id, :options)
  end
  
end
