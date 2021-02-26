class Api::QuestionForUsersController < ApplicationController

    before_action :role_is_admin, only: [:create, :update, :destroy]
  
    def index
      current_user.current_role
      role = Role.find_by(name: current_user.current_role)
      if role_is_admin
       @questions = Question.joins("INNER JOIN question_types on questions.question_type_id = question_types.id").select("questions.id, questions.question, questions.options,question_types.q_type")
      else  
       @questions = Question.joins("INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id").where("question_for_users.quarter = ? AND question_for_users.role_id = ? And question_for_users.status = ?",current_quarter,role.id, "true").select("question_for_users.id, questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status")
      end  
      (@questions.empty?) ? (render :json => {:message => "Sorry! question is not available for this role"}) : (render json: @questions.as_json)
    end
    
    def create
      @error = add_question(params[:question_for_users])
      unless @error.present?
        render json: {message: "Question add successfully for this role!",}
      else
        render json: @error
      end
    end
   
    def update
      @question_update = QuestionForUser.find(params[:id])
      (@question_update.status == "true") ? (status = "false") : (status = "true")
      @question_update.update(status: status) ? (render :json => {:message => "Question status update successfully"}) : (render json: @question_update.errors)
    end

    def destroy
      @question_for_user
      (@question_for_user.destroy) ? (render json: {:message => "Question Delete successfully for this role!"}) : (render json: @question_for_user.errors)
    end
   
    private

      def add_question(user_question_list)
        error = ""
          ActiveRecord::Base.transaction do
            user_question_list.map do |data|
              @question = QuestionForUser.new(data.as_json)
              @question.quarter = current_quarter
              @question.role_id = params[:user_role_id] 
              unless @question.save
                error = @question.errors.full_messages
                raise ActiveRecord::Rollback
              end
            end      
          end
        error
      end
  
      def question_params
        params.require(:user_question_list).permit(:question_id, :role_id, :status)
      end
end  