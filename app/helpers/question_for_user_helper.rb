module QuestionForUserHelper
  def alloted_question
    @question_list = []
    @questions.map do |data|
      @question = data.question
      @question_type = QuestionType.find(@question.question_type_id)
      alloted_question = @question.attributes.merge(question_type: @question_type.q_type,
                                                    question_for_user_id: data.id)
      @question_list.push(alloted_question)
    end
    { 'question' => @question_list }
  end

  def add_question(user_question_list)
    error = ''
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