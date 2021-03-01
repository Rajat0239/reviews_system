class ReviewSystem::QuestionsController < ApplicationController

  def index
    @questions = Question.all
    @role_id = params[:role_id]
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
