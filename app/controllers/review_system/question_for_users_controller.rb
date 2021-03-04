class ReviewSystem::QuestionForUsersController < ApplicationController
    before_action :role_is_admin, only: [:create, :update, :destroy]
  
    def index
      @questions = QuestionForUser.where(role_id: role_id).joins(:question)
      alloted_question
      (alloted_question.empty?) ? (render :json => {:message => "Sorry! question is not available for this role"}) : (render json: alloted_question)
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

  def alloted_question
    @question_list = []
    @questions.map do |data|
      @question = data.question
      @question_type = QuestionType.find(@question.question_type_id)
      alloted_question = @question.attributes.merge(:question_type => @question_type.q_type, :question_for_user_id => data.id)        
      @question_list.push(alloted_question)
    end 
    return {"question" => @question_list}
  end  

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