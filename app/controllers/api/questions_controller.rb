class Api::QuestionsController < ApplicationController

  before_action :role_is_admin, only: [:create, :update, :index]

  def index
    current_user.current_role
    role = Role.find_by(name: current_user.current_role)
    if role_is_admin
     @question = Question.joins("INNER JOIN question_types on questions.question_type_id = question_types.id").select("questions.id, questions.question, questions.options,question_types.q_type")
    elsif role_is_manager
     @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role.id).select("questions.id, questions.question, questions.options, roles.name,question_types.q_type")
    else  
     @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role.id).select("questions.id, questions.question, questions.options, roles.name,question_types.q_type")
    end  

    (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role"}) : (render json: @question.as_json)
  end

  def create
    @error = create_question(params[:question_list])
    unless @error.present?
      render json: {message: "Question created successfully",}
    else
      render json: @error
    end
  end

  def update
    @question.update(params[:question].as_json) ? (render :json => {:message => "question updated successfully"}) : (render json: @question)
  end

  private

    def create_question(question_list)
      error = ""
        ActiveRecord::Base.transaction do
          question_list.map do |data|
            @question = Question.new(data.as_json)
            unless @question.save
              error = @question.errors.full_messages
              raise ActiveRecord::Rollback
            end
          end      
        end
      error
    end

    # def question_params
    #   params.require(:question_list).permit(:question, :question_type_id, :options)
    # end
end
