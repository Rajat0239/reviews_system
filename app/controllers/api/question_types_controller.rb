class Api::QuestionTypesController < ApplicationController

  def index
    @question_type = QuestionType.all
    render json: @question_type.as_json(only: [:id, :q_type])
  end

end