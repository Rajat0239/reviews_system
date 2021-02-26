class ReviewSystem::QuestionsController < ApplicationController

  before_action :role_is_admin, only: [:create, :update, :index]

  def index
    @question = []
    if role_is_admin
     @question = Question.joins("INNER JOIN question_types on questions.question_type_id = question_types.id").select("questions.id, questions.question, questions.options,question_types.q_type")
    end  
    (@question.empty?) ? (render :json => {:message => "Sorry! question is not available !"}) : (render json: @question.as_json)
  end

  def manager_question_list
    role_id = "2"      
     @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role_id).select("question_for_users.id, question_for_users.question_id,questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
     @questions = QuestionBackup.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on question_backups.question_id = question_for_users.question_id INNER JOIN question_types on question_types.id = question_backups.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? And question_for_users.status = ? ",current_quarter,role.id, status).select("question_for_users.id, question_backups.question, question_backups.options, roles.name,question_types.q_type,question_for_users.status") if @questions.empty?
    
     (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role !"}) : (render json: @question.as_json)
  end

  def employee_question_list
    role_id = "3" 
     @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role_id).select("question_for_users.id, questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
     (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role !"}) : (render json: @question.as_json)
  end

  def create
    @question = Question.new(params[:question_list].as_json)
    byebug
    @question.save ? (render json: {message: "Question created successfully"}) : (render json: @question.errors)
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def update
    @question = Question.find(params[:id])
    @question.update(params[:question_list].as_json) ? (render :json => {:message => "question updated successfully"}) : (render json: @question.errors)
  end

  def destroy
    @question
    (@question.destroy) ? (render json: {:message => "Question Delete successfully !"}) : (render json: @question.errors)
  end
  
end
