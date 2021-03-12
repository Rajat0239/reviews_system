module QuestionHelper
  def get_question(role_id)
    if role_id == '1'
      @question = QuestionType.joins(:questions).where('questions.status = ?',
                                                       1).select('questions.id, questions.question, questions.options,question_types.q_type, questions.status')
    else
      @question = Question.joins('INNER JOIN roles ON roles.id = question_for_users.role_id INNER JOIN question_for_users on questions.id = question_for_users.question_id INNER JOIN question_types on question_types.id = questions.question_type_id').where(
        'question_for_users.quarter = ? AND question_for_users.role_id = ? AND questions.status = ?', current_quarter, role_id, 1
      ).select('question_for_users.id, question_for_users.question_id,questions.question, questions.options, roles.name,question_types.q_type,question_for_users.status')
    end    
  end
end
