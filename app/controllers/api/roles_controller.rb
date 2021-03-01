class Api::RolesController < ApplicationController
  
  def index
    @roles = Role.all
    render json: @roles
  end

  def create
    @role = Role.new(name:params[:user_roles][:name])
    @role.save ? (render json: {:message => "Role Create successfully"}) : (render json: @role.errors)
  end 
  
  # def manager_question_list
  #@role
  #   role_id = "2" 
  #    @question = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? ",current_quarter,role_id).select("question_for_users.id, question_for_users.question_id,questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
  #    @questions = QuestionBackup.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on question_backups.question_id = question_for_users.question_id INNER JOIN question_types on question_types.id = question_backups.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? And question_for_users.status = ? ",current_quarter,role.id, status).select("question_for_users.id, question_backups.question, question_backups.options, roles.name,question_types.q_type,question_for_users.status") if @questions.empty?
    
  #    (@question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role !"}) : (render json: @question.as_json)
  # end

  def update
    @role = Role.find(params[:id])
    @role.update(name:params[:user_roles][:name]) ? (render json: {:message => "Role update successfully"}) : (render json: @role.errors)
  end
  
  def destroy
    @role = Role.find(params[:id])
    (@role.destroy) ? (render json: {:message => "Role delete successfully"}) : (render json: @role.errors)
  end
  
  private
  
    def user_params
      byebug
      params.require(:user_roles).permit(:name) 
    end
end
