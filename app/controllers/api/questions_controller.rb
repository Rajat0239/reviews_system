class Api::QuestionsController < ApplicationController

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
    (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role !"}) : (render json: @question.as_json)
  end

  def employee_question_list
    role_id = "3" 
     @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role_id).select("question_for_users.id, questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
    (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role !"}) : (render json: @question.as_json)
  end

  def create
    @question = Question.new(params[:question_list].as_json)
    @question.save ? (render json: {message: "Question created successfully"}) : (render json: @question.errors)
    
    # .......for create multiple question .........
    #   @error = create_question(params[:question_list])
    # unless @error.present?
    #   render json: {message: "Question created successfully",}
    # else
    #   render json: @error
    # end
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

  private

    # def create_question(question_list)
    #   error = ""
    #     ActiveRecord::Base.transaction do
    #       question_list.map do |data|
    #         @question = Question.new(data.as_json)
    #         unless @question.save
    #           error = @question.errors.full_messages
    #           raise ActiveRecord::Rollback
    #         end
    #       end      
    #     end
    #   error
    # end

    # def question_params
    #   params.require(:question_list).permit(:question, :question_type_id, :options)
    # end
end
